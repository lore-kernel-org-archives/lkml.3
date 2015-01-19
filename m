Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbbASK2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 05:28:39 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:63632 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbbASK2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 05:28:37 -0500
Date: Mon, 19 Jan 2015 11:28:44 +0100
From: Johan Hovold <johan@kernel.org>
To: Colin King <colin.king@canonical.com>
Cc: Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/usb/serial/mos7840.c: remove unused code
Message-ID: <20150119102844.GN30960@localhost>
References: <1421170905-13233-1-git-send-email-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421170905-13233-1-git-send-email-colin.king@canonical.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 05:41:45PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is old, unused code that is #defined out by the
> use of NOTMOS7840 - this is not defined anywhere.  If
> NOTMOS7840 is defined then the code will break on null
> pointer dereferences on mos7840_port.  So the code is
> currently unused, and broken anyway, so why not just
> remove it.

Makes sense. But why not remove the likewise broken code conditionally
compiled on NOTMCS7840 as well?

Care to resend and include that as well?

Thanks,
Johan
