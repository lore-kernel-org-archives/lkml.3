Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbaJPJGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:06:41 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:35718 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaJPJGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:06:39 -0400
MIME-Version: 1.0
In-Reply-To: <1413450267-24760-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1413450267-24760-1-git-send-email-ricardo.ribalda@gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Thu, 16 Oct 2014 11:06:17 +0200
Message-ID: <CAPybu_1SEJhUqSxHof6a18WzpUniGL6Gp4ByA8Ekr-oGZaFM7g@mail.gmail.com>
Subject: Re: [PATCH] tty/serial_core: Introduce lock mechanism for RS485
To: linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just realized I forgot to add the v2 on the subject.
