Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbbALJ1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:27:39 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:35373 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbbALJ1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:27:37 -0500
Date: Mon, 12 Jan 2015 10:27:42 +0100
From: Johan Hovold <johan@kernel.org>
To: Jeremiah Mahler <jmmahler@gmail.com>
Cc: Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v3 0/2] usb: serial: silence non-critical unplug read
 errors
Message-ID: <20150112092742.GD23221@localhost>
References: <1419066698-2684-1-git-send-email-jmmahler@gmail.com>
 <1420983727-5167-1-git-send-email-jmmahler@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420983727-5167-1-git-send-email-jmmahler@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2015 at 05:42:05AM -0800, Jeremiah Mahler wrote:
> If a USB serial device (e.g. /dev/ttyUSB0) with an active program is
> unplugged, a bunch of -ENODEV and -EPROTO errors may be produced in the
> logs.  This patch set quiets these messages without changing the
> original behavior.

Both patches applied, thanks.

Johan
