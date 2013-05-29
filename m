Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965142Ab3E2RzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 13:55:25 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:46878 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934979Ab3E2RzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 13:55:20 -0400
MIME-Version: 1.0
In-Reply-To: <1369793454-19197-4-git-send-email-grant.likely@linaro.org>
References: <1369793454-19197-1-git-send-email-grant.likely@linaro.org>
	<1369793454-19197-4-git-send-email-grant.likely@linaro.org>
Date: Wed, 29 May 2013 19:55:19 +0200
Message-ID: <CACRpkdYjph7swctH0VUJTnEX3O2EKEhX3_HcZz0JvK9L+NKhdA@mail.gmail.com>
Subject: Re: [PATCH 3/3] irqchip: Make versatile fpga irq driver a generic chip
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 4:10 AM, Grant Likely <grant.likely@linaro.org> wrote:

> This is an RFC patch to convert the versatile FPGA irq controller driver
> to use generic irq chip. It builds on the series that extends the
> generic chip code to allow a linear irq domain to contain one or more
> generic irq chips so that each interrupt controller doesn't need to hand
> code the generic chip setup.
>
> I've written this as a proof of concept to see if the new generic irq
> code does what it needs to. I had to extend it slightly to properly
> handle the valid mask used by the versatile FPGA driver.
>
> Tested on QEMU, but not on real hardware.


Hm, I could test this but what is the needed baseline? I think
I need Thomas' patches underneath right?

Could you publish a branch that I can test?

Yours,
Linus Walleij
