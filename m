Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbaAONR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 08:17:58 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:44562 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbaAONRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 08:17:55 -0500
Message-ID: <1389791864.9124.5.camel@host5.omatika.ru>
Subject: Re: [PATCH v3 11/21] ARM: pxa: support ICP DAS LP-8x4x FPGA irq
From: Sergei Ianovich <ynvich@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
Date: Wed, 15 Jan 2014 17:17:44 +0400
In-Reply-To: <CACRpkda_6P3s3LBwV5ve+=_JhxehephvpPT=pKPk3NzEKQLa9g@mail.gmail.com>
References: <1386901645-28895-1-git-send-email-ynvich@gmail.com>
	 <1387309071-22382-1-git-send-email-ynvich@gmail.com>
	 <1387309071-22382-12-git-send-email-ynvich@gmail.com>
	 <CACRpkdaY7xpoeeUqBBqUS2swe6Y5gKt67VYNvNRrsbFhyU=ATw@mail.gmail.com>
	 <1389207661.10754.42.camel@host5.omatika.ru>
	 <CACRpkda_6P3s3LBwV5ve+=_JhxehephvpPT=pKPk3NzEKQLa9g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-15 at 08:39 +0100, Linus Walleij wrote:
> On Wed, Jan 8, 2014 at 8:01 PM, Sergei Ianovich <ynvich@gmail.com> wrote:
> Hm I don't know why I was deluded into thinking this had something to
> do with GPIO. I must have been soft in the head. Sorry about all those
> comments ...

It's not your fault for sure. My commit message wasn't clear enough and
needed clarifications. It is better now.

Thanks for constructive reviewing.

