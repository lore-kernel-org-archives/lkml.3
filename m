Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbaIWPgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:36:09 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:57557 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbaIWPgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:36:04 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Tue, 23 Sep 2014 17:33:30 +0200
From: Johan Hovold <johan@kernel.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: Re: [PATCH v2 05/14] usb: serial: Remove unused tty->hw_stopped
Message-ID: <20140923153330.GA4524@localhost>
References: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
 <1410375996-4693-1-git-send-email-peter@hurleysoftware.com>
 <1410375996-4693-6-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410375996-4693-6-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 03:06:27PM -0400, Peter Hurley wrote:
> The tty core does not test tty->hw_stopped; remove from drivers
> which don't test it themselves.
> 
> cc: Johan Hovold <johan@kernel.org>
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>

Acked-by: Johan Hovold <johan@kernel.org>
