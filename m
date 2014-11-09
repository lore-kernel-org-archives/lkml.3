Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbaKISTk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 13:19:40 -0500
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:50702 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaKISTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 13:19:38 -0500
X-ME-Helo: beldin
X-ME-Date: Sun, 09 Nov 2014 19:19:35 +0100
X-ME-IP: 109.222.82.103
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
Date: Sun, 09 Nov 2014 19:19:33 +0100
In-Reply-To: <CALT56yOU=cqczdEs=FOgoWUHev1A0gihEpV-XsD5_g_ECz6+Qg@mail.gmail.com>
	(Dmitry Eremin-Solenikov's message of "Sun, 9 Nov 2014 20:11:27
	+0400")
Message-ID: <87fvdsuthm.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Eremin-Solenikov <dbaryshkov@gmail.com> writes:

> 2014-11-09 0:01 GMT+03:00 Robert Jarzmik <robert.jarzmik@free.fr>:
> Tested-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
OK, that's really great, thanks for your testing effort.
I'll digest the clk_summary output next week to cross-check everything is in
order.

> Could you please also include a revert of
> 23c4a3a5212701ad34bd30591fa33d7bacef9c5f
> into your branch? Otherwise pxa27x is broken in your tree.
Done.

I will release v2 of this serie very soon now as the fixes for at least 2
pxa25x platforms are identified and done.

Cheers.

-- 
Robert
