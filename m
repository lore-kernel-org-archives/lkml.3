Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab3G2IUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 04:20:06 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:57305 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab3G2IUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 04:20:05 -0400
MIME-Version: 1.0
X-Originating-IP: [218.173.174.253]
In-Reply-To: <1375082774.7272.1.camel@phoenix>
References: <1375082774.7272.1.camel@phoenix>
Date: Mon, 29 Jul 2013 16:20:03 +0800
Message-ID: <CAFRkauB35ERLgakua7=Q+xoRx-N83BTD4f_8HyvbGjAxhEZvUg@mail.gmail.com>
Subject: Re: regulator: pfuze100: A few small questions
From: Axel Lin <axel.lin@ingics.com>
To: Robin Gong <b38343@freescale.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/29 Axel Lin <axel.lin@ingics.com>:
> Hi Robin,
> 2 questions about the code in pfuze100 driver:
>
> 1)
> Both PFUZE100_REVID and PFUZE100_FABID are defined as 0x3.
> So I'm wondering if it's a typo in one of the register address?
> If they are actually the same register, we don't need to read the same
> register twice in pfuze_identify().
>
> 2)
> What is the the purpose of stby_reg and stby_mask?
> Seems current code does not use it?


One more question:

Current code adjust min_uV and uV_step when SW2~SW4 high bit is set.
I'm wondering if n_voltages is correct or not in this case because
the n_voltages is calculated by original equation (max-min/step + 1).
What is the max_uV when SW2~SW4 high bit is set?

Regards,
Axel
