Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbaEUVjj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 17:39:39 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:39289 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbaEUVjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 17:39:36 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:fd1f:c4dc:b681:cd4a:92c0]
In-Reply-To: <20140521211105.GD24341@quad.lixom.net>
References: <1400059162-630-1-git-send-email-nicolas.ferre@atmel.com>
	<20140520055041.GO18956@quad.lixom.net>
	<537B727C.5080404@atmel.com>
	<20140520164746.GA601@quad.lixom.net>
	<537C7D25.6060705@atmel.com>
	<20140521211105.GD24341@quad.lixom.net>
Date: Wed, 21 May 2014 14:39:35 -0700
Message-ID: <CAOesGMgYe=8usEDMemLfwu-amfiEJAWCqKu4GjV4oLwK8u8K0w@mail.gmail.com>
Subject: Re: [GIT PULL] at91: DT for 3.16 #2
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, "arm@kernel.org" <arm@kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Wenyou Yang <wenyou.yang@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 2:11 PM, Olof Johansson <olof@lixom.net> wrote:

> I don't agree with everything above, but it's not worth arguing for the
> sake of arguing. :) I think we can tweak what you're doing now and get
> things to work well by merging new dts files with at91-<soc>-board.dts
> as the name. As mentioned, don't worry about the existing files. This
> shouldn't be a significiant change to what you've been telling people
> since 3.10 to cause much confusion.

A the end of the day, as long as you have at91- as prefix we'll be OK I think.

If you can consistently add the SoC into the prefix as above, we'll be
even better. But I'm not going to spend more time arguing it. :)

Either way, consistency (going forward) with at91- is good.

-Olof
