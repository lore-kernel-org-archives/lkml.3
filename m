Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbaAHUzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 15:55:38 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:54343 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757101AbaAHUzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 15:55:35 -0500
MIME-Version: 1.0
In-Reply-To: <CACUGKYPZefRPr73Wq+700qeFiDYHmLr4kSFCvkYRojHoE4ZxxA@mail.gmail.com>
References: <1389210991-23688-1-git-send-email-john.tobias.ph@gmail.com>
	<1389211403.678513817@f123.i.mail.ru>
	<CAOMZO5DR0YGc=V5PJ6xy5PNwa9LCVfnS9gbRh1yW9wLo_oTEtw@mail.gmail.com>
	<CACUGKYPZefRPr73Wq+700qeFiDYHmLr4kSFCvkYRojHoE4ZxxA@mail.gmail.com>
Date: Wed, 8 Jan 2014 12:55:33 -0800
Message-ID: <CACUGKYNLZzy+Pc+LLYmRrdgBUaOJV+wnEtT7qJH6aZyVBXYSJA@mail.gmail.com>
Subject: Re: [PATCH v3] ARM: imx: add select on ARCH_MXC for cpufreq support
From: John Tobias <john.tobias.ph@gmail.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Alexander Shiyan <shc_work@mail.ru>, Shawn Guo <shawn.guo@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recompiled the kernel using the said config and it works. But, if
you have any other suggestion it would be great.

Regards,

john

On Wed, Jan 8, 2014 at 12:45 PM, John Tobias <john.tobias.ph@gmail.com> wrote:
> Hi Fabio,
>
> How about select HAVE_IMX_ANATOP if SOC_IMX6Q || SOC_IMX6SL
>
> Regards,
>
> john
>
> On Wed, Jan 8, 2014 at 12:33 PM, Fabio Estevam <festevam@gmail.com> wrote:
>> On Wed, Jan 8, 2014 at 6:03 PM, Alexander Shiyan <shc_work@mail.ru> wrote:
>>
>>> Maybe better:
>>> select HAVE_IMX_ANATOP if ARCH_MULTI_V6_V7
>>
>> mx31, mx35, mx51 and mx53 do not have this ANATOP block.
>>
>> Regards,
>>
>> Fabio Estevam
