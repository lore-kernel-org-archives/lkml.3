Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaJBMYA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 08:24:00 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:50279 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbaJBMX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 08:23:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Olof Johansson <olof@lixom.net>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: soc for 3.18 #3
Date: Thu, 02 Oct 2014 14:23:53 +0200
Message-ID: <2674694.XlUc134s25@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1412184003-13568-1-git-send-email-nicolas.ferre@atmel.com>
References: <1412184003-13568-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:kuKuqGUzQBE10bZ4hqu8ThCT3Z6Vbo3bk0Y5YpT9HuS
 ruLDu6DJzs2FP8WZ6A6X23TncHfSj84KpPz5jx38pZXnZiIDPS
 S8pOI7ui8FZsmusFSntcw/P8IyEvFmWXPk6cjNM0QajE/GNMOX
 mHOIGzYUr0pgk3ApZg91q0EY1TNjYTBZFGfjOT0LS5976iSzcy
 4inrIOoSEc2v/TLeipah4tY0o9AcK7L0eji/ctESZogOSNS2jA
 8epIw4PGcq7yR6GqoNMZ+fvuzrr5f1iIKEIzJuHb2zmobw58fm
 tvrM0ExvDleqj5rhwzcrD/MqfQEHW3MklazEytRtKba1kmi82J
 EXO0SE0MeenYdhTBUkv4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2014 19:20:03 Nicolas Ferre wrote:
> Arnd, Olof, Kevin,
> 
> Another pull-request for 3.18 if you feel it can be stacked up now. This one is
> *only* about removing code: the old !MMU at91x40 and 2 board files plus the whole
> code in at91sam9g45 & at91sam9rl files for implementing this deprecated method:
> as the EK were the only one to use this code, we remove quite a bunch of lines.
> We can use these boards with DT right now.
> As a matter of fact, the diffstat is pretty nice 
> 

I love the changes, but I've pretty much decided to put a hard stop
on all new pull request after introducing a few regressions with
late submissions.

	Arnd
