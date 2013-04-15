Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab3DOPME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:12:04 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:44081 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab3DOPMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:12:03 -0400
Message-ID: <1366038710.4124.2.camel@thor.lan>
Subject: Re: [PATCH 0/4] TTY: fix DTR being raised on hang up
From: Peter Hurley <peter@hurleysoftware.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, "David S. Miller" <davem@davemloft.net>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 15 Apr 2013 11:11:50 -0400
In-Reply-To: <1365755551-17824-1-git-send-email-jhovold@gmail.com>
References: <1365755551-17824-1-git-send-email-jhovold@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-12 at 10:32 +0200, Johan Hovold wrote:
> These patches fix four custom block_til_ready implementations which
> could raise DTR after first having dropped it at hangup.
> 
> This was fixed in the tty-port implementation by commit e584a02cf ("TTY:
> fix DTR being raised on hang up") in tty-next.
> 
> Note that the crisv10-driver still suffers from this behaviour but is
> broken in other ways as it, for example, does not honour CBAUD or raise
> DTR at non-blocking open.

Thanks for fixing these.

Regards,
Peter Hurley


