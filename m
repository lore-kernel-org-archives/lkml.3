Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab3LQDH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 22:07:26 -0500
Received: from mail-qe0-f43.google.com ([209.85.128.43]:43615 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab3LQDHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 22:07:20 -0500
MIME-Version: 1.0
In-Reply-To: <20131217132838.cc16a4dbac2f4d3218bbed1d@canb.auug.org.au>
References: <20131213125716.f432c59bf8782a489400a5a7@canb.auug.org.au>
	<20131217132838.cc16a4dbac2f4d3218bbed1d@canb.auug.org.au>
Date: Tue, 17 Dec 2013 11:07:19 +0800
Message-ID: <CAA+hA=Shwn1P25+xB+VogD+9n7gdvCmJ-EG6khgf3a2gjGwTJQ@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the mmc tree
From: Dong Aisheng <dongas86@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Chris Ball <cjb@laptop.org>, linux-next@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dong Aisheng <b29396@freescale.com>, Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Sorry, i just see this mail.
It seems the imx pinctrl dt binding has changes since Chris pick my patch.
I will fix it ASAP.

Regards
Dong Aisheng

On Tue, Dec 17, 2013 at 10:28 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Chris,
>
> ping?
>
> On Fri, 13 Dec 2013 12:57:16 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> After merging the mmc tree, today's linux-next build (arm
>> multi_v7_defconfig) failed like this:
>>
>> ERROR (phandle_references): Reference to non-existent node or label "pinctrl_usdhc4_1"
>>
>> ERROR: Input tree has errors, aborting (use -f to force output)
>> make[2]: *** [arch/arm/boot/dts/imx6dl-sabresd.dtb] Error 2
>> ERROR (phandle_references): Reference to non-existent node or label "pinctrl_usdhc4_1"
>>
>> ERROR: Input tree has errors, aborting (use -f to force output)
>> make[2]: *** [arch/arm/boot/dts/imx6q-sabresd.dtb] Error 2
>>
>> Caused by commit fc4fafac9656 ("ARM: dts: sabresd: add usdhc4 support").
>>
>> I have used the mmc tree from next-20131212 for today.
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
