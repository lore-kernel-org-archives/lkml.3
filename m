Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaEBNJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 09:09:51 -0400
Received: from vserver.eikelenboom.it ([84.200.39.61]:50362 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbaEBNJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 09:09:49 -0400
From: Sander Eikelenboom <linux@eikelenboom.it>
To: Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julia Lawall <julia.lawall@lip6.fr>
Cc: Sander Eikelenboom <linux@eikelenboom.it>, linux-sound@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Prevent printk ratelimiting from spamming kernel log while DEBUG not defined
Date: Fri,  2 May 2014 15:09:26 +0200
Message-Id: <1399036167-6203-1-git-send-email-linux@eikelenboom.it>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

This patch is for USB sound, but the construction is widely used in the kernel,
so this could pop up in more places.

Greg, Julia,

Would it be worthwhile to sweep this tree wide ?
And would this be something for Coccinelle ?
This probably also goes for the other loglevels and the "net" variant.


Sander Eikelenboom (1):
  Sound USB: Prevent printk ratelimiting from spamming kernel log while
    DEBUG not defined

 sound/usb/pcm.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

-- 
1.7.10.4

