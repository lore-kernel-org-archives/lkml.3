Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577AbbASPAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 10:00:06 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:64027 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbbASPAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 10:00:04 -0500
Date: Mon, 19 Jan 2015 16:00:14 +0100
From: Johan Hovold <johan@kernel.org>
To: Colin King <colin.king@canonical.com>
Cc: Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][V2] drivers/usb/serial/mos7840.c: remove unused code
Message-ID: <20150119150014.GS30960@localhost>
References: <1421674378-14451-1-git-send-email-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421674378-14451-1-git-send-email-colin.king@canonical.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 01:32:58PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is old, unused code that is #defined out by the
> use of NOTMOS7840 and NOTMCS7840 - these are not
> defined anywhere.
> 
> If NOTMOS7840 is defined then the code will break on null
> pointer dereferences on mos7840_port.  So the code is
> currently unused, and broken anyway, so why not just
> remove it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Thanks for the update. Applied for next now.

Johan
