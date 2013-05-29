Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966506Ab3E2T45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 15:56:57 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:45295 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758817Ab3E2T4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 15:56:50 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYjph7swctH0VUJTnEX3O2EKEhX3_HcZz0JvK9L+NKhdA@mail.gmail.com>
References: <1369793454-19197-1-git-send-email-grant.likely@linaro.org>
 <1369793454-19197-4-git-send-email-grant.likely@linaro.org> <CACRpkdYjph7swctH0VUJTnEX3O2EKEhX3_HcZz0JvK9L+NKhdA@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 29 May 2013 20:56:29 +0100
X-Google-Sender-Auth: UxvwtgGLJsyIt0EwZkg-6kSr2N4
Message-ID: <CACxGe6vP0F+E_UwULykPLyurO_uDQMVQhShR5VXJ7k0FynuTDw@mail.gmail.com>
Subject: Re: [PATCH 3/3] irqchip: Make versatile fpga irq driver a generic chip
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 6:55 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Wed, May 29, 2013 at 4:10 AM, Grant Likely <grant.likely@linaro.org> wrote:
>
>> This is an RFC patch to convert the versatile FPGA irq controller driver
>> to use generic irq chip. It builds on the series that extends the
>> generic chip code to allow a linear irq domain to contain one or more
>> generic irq chips so that each interrupt controller doesn't need to hand
>> code the generic chip setup.
>>
>> I've written this as a proof of concept to see if the new generic irq
>> code does what it needs to. I had to extend it slightly to properly
>> handle the valid mask used by the versatile FPGA driver.
>>
>> Tested on QEMU, but not on real hardware.
>
>
> Hm, I could test this but what is the needed baseline? I think
> I need Thomas' patches underneath right?
>
> Could you publish a branch that I can test?

Try this one:

git://git.secretlab.ca/git/linux irqdomain/generic-chip

g.
