Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaLQH6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 02:58:42 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:63471 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbaLQH6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 02:58:41 -0500
Message-ID: <5491379F.3090607@i2se.com>
Date: Wed, 17 Dec 2014 08:58:23 +0100
From: Stefan Wahren <stefan.wahren@i2se.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: Marek Vasut <marex@denx.de>, linux-kernel <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RFC] clk: mxs: Fix invalid 32-bit access to frac registers
References: <1418570933-21585-1-git-send-email-stefan.wahren@i2se.com>	<201412141712.12589.marex@denx.de>	<1638147247.144508.1418577377536.JavaMail.open-xchange@oxbaltgw03.schlund.de> <CAOMZO5CQjpYtrNTT65-ikJua4N_osYj4UVgm3EV+sEvVWF59cg@mail.gmail.com>
In-Reply-To: <CAOMZO5CQjpYtrNTT65-ikJua4N_osYj4UVgm3EV+sEvVWF59cg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:eGQxT04g6vNwrUAy6wLtZr+VUUvcWcVhsIowahozhjdFmraDXwD
 jHegRKYj92rH7AoDT1T4X5fYrWUsbo+O+eAwf192rhM8mu498cUO7RGg0lKPYFMdil8t2zt
 9UHmIFlbhVc+gIUtVljBJXsYoXbR3LMLG1VhBmjzun34KTzDyV89uZsfKeTdO1XtNoILO5J
 37AXySRinV6VE3bcUs3VA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabio,

Am 17.12.2014 um 03:44 schrieb Fabio Estevam:
> Hi Stefan,
>
> On Sun, Dec 14, 2014 at 3:16 PM, Stefan Wahren <stefan.wahren@i2se.com> wrote:
>
>> Btw i hope this patch also fixes a SPI communication issue with our hardware
>> which forces us to bypass ref_io1 for ssp2.
> Does this patch fix the SPI issue?

unfortunately not. If the 3.19-rc1 has been released, i send the fixed
patch.

I've the theory that's an initialization issue. I've never heard of SPI
problems from the U-Boot users and we are using imx-bootlets.

I'll try to test it with U-Boot.

Stefan
