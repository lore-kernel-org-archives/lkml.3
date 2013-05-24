Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab3EXRLg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 13:11:36 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:56179 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab3EXRLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 13:11:35 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <1369410151-7837-1-git-send-email-nicolas.ferre@atmel.com>
References: <1369410151-7837-1-git-send-email-nicolas.ferre@atmel.com>
Date: Fri, 24 May 2013 10:11:33 -0700
Message-ID: <CAOesGMjvKhVKZf9A70K7VzXikY902KVyKR==4ivnb-gxhyRCPQ@mail.gmail.com>
Subject: Re: [GIT PULL] at91: fixes for 3.10 #2
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, b.brezillon@overkiz.com,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'll pull this for now, but...


> Jean-Christophe PLAGNIOL-VILLARD (1):
>       ARM: at91: at91sam9n12: move external irq declatation to DT

This one is not a fix. While OK this time, please stick to only
sending true fixes for 3.10 from here on out.


-Olof
