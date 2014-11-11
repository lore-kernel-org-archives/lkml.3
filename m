Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbaKKKKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 05:10:09 -0500
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:60248 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaKKKKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 05:10:07 -0500
X-ME-Helo: beldin
X-ME-Date: Tue, 11 Nov 2014 11:10:04 +0100
X-ME-IP: 90.16.212.42
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Ian Molton <ian.molton@codethink.co.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Daniel Mack <zonque@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 0/3] Transition pxa25x clock to common clocks
References: <1414941415-13146-1-git-send-email-robert.jarzmik@free.fr>
	<CALT56yOCBN1NAfNw=vThVZ_o=ONGOTvzKHBH5tCTQShJY0wkrQ@mail.gmail.com>
	<87lhnlwqm4.fsf@free.fr>
	<CALT56yNOXq-ssvsjafz=ae+uWv1GyscoQ3RQ_h--i740zm4trA@mail.gmail.com>
	<8761epwgni.fsf@free.fr>
	<CALT56yOU=cqczdEs=FOgoWUHev1A0gihEpV-XsD5_g_ECz6+Qg@mail.gmail.com>
X-URL: http://belgarath.falguerolles.org/
Date: Tue, 11 Nov 2014 11:09:55 +0100
In-Reply-To: <CALT56yOU=cqczdEs=FOgoWUHev1A0gihEpV-XsD5_g_ECz6+Qg@mail.gmail.com>
	(Dmitry Eremin-Solenikov's message of "Sun, 9 Nov 2014 20:11:27
	+0400")
Message-ID: <8761emujyk.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Eremin-Solenikov <dbaryshkov@gmail.com> writes:

> 2014-11-09 0:01 GMT+03:00 Robert Jarzmik <robert.jarzmik@free.fr>:
>    clock                         enable_cnt  prepare_cnt        rate
> accuracy   phase
> ----------------------------------------------------------------------------------------
>  clk_dummy                                0            0           0
>        0 0
>  osc_32_768khz                            3            3    32768000
Here the clock rate should be 1000 times slower, for v3.

>     ppll_147_46mhz                        2            4   147456000
>        0 0
>        AC97                               1            1    12288000
This is not the same value as before, but given that the manual states this
value and that AC97 clock's rate is not used by its driver (probably because the
clock is driven by the codec if I remember correctly), that will stay this way.

>        0 0
>        I2S                                0            0   147456000
Here to clock rate is 10 times too quick, for v3.

Cheers.

-- 
Robert
