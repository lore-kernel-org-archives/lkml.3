Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbaJMTDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 15:03:22 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:64466 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbaJMTDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 15:03:20 -0400
MIME-Version: 1.0
In-Reply-To: <20141013145229.4849f07a@alan.etchedpixels.co.uk>
References: <1412948280-30993-1-git-send-email-ricardo.ribalda@gmail.com> <20141013145229.4849f07a@alan.etchedpixels.co.uk>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 13 Oct 2014 21:02:57 +0200
Message-ID: <CAPybu_316A6DZ7MOFm=6vHw2vfS+6_CnZD5J4wVJkbRa1Ycnuw@mail.gmail.com>
Subject: Re: [PATCH] tty/serial_core: Introduce lock mechanism for RS485
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alan

>> +     spin_unlock_irqrestore(&port->lock, flags);
>
> Looks good apart from this bit.. The copy needs to go to a temporary
> before the lock is taken otherwise we may sleep on a pagefault with irqs
> off
>
> Alan

Good catch

I will fix it as you suggest.

I will give a give a couple of days for comments about the serie
"[PATCH 00/12] Handle TIOC[GS]RS485
iocts on serial_core"  Then I will resend the series including this
patch (of course, fixed)


Thanks!


-- 
Ricardo Ribalda
