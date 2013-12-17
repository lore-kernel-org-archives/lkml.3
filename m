Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab3LQIGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 03:06:23 -0500
Received: from mail-qe0-f45.google.com ([209.85.128.45]:36862 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab3LQIGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 03:06:20 -0500
MIME-Version: 1.0
In-Reply-To: <20131217031600.GG6691@S2101-09.ap.freescale.net>
References: <20131213125716.f432c59bf8782a489400a5a7@canb.auug.org.au>
	<20131217132838.cc16a4dbac2f4d3218bbed1d@canb.auug.org.au>
	<CAA+hA=Shwn1P25+xB+VogD+9n7gdvCmJ-EG6khgf3a2gjGwTJQ@mail.gmail.com>
	<20131217031600.GG6691@S2101-09.ap.freescale.net>
Date: Tue, 17 Dec 2013 16:06:19 +0800
Message-ID: <CAA+hA=QU1TApbbohD1iNFiMMMHdQSamRfOsO0r3GpqmCbdiSgw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the mmc tree
From: Dong Aisheng <dongas86@gmail.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Chris Ball <cjb@laptop.org>,
        linux-next@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dong Aisheng <b29396@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tested that Chris tree does not have problem.
It's caused by IMX tree updates.

Chris,
Is the way Shawn suggested OK for you?

Regards
Dong Aisheng

On Tue, Dec 17, 2013 at 11:16 AM, Shawn Guo <shawn.guo@linaro.org> wrote:
> Hi Chris,
>
> Please drop fc4fafac9656 ("ARM: dts: sabresd: add usdhc4 support") from
> your tree.  It should go via my tree (with a rebase).  Sorry, I did not
> notice it early.
>
> Shawn
>
> On Tue, Dec 17, 2013 at 11:07:19AM +0800, Dong Aisheng wrote:
>> Hi Stephen,
>>
>> Sorry, i just see this mail.
>> It seems the imx pinctrl dt binding has changes since Chris pick my patch.
>> I will fix it ASAP.
>>
>> Regards
>> Dong Aisheng
>>
>> On Tue, Dec 17, 2013 at 10:28 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> > Hi Chris,
>> >
>> > ping?
>> >
>> > On Fri, 13 Dec 2013 12:57:16 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> >>
>> >> After merging the mmc tree, today's linux-next build (arm
>> >> multi_v7_defconfig) failed like this:
>> >>
>> >> ERROR (phandle_references): Reference to non-existent node or label "pinctrl_usdhc4_1"
>> >>
>> >> ERROR: Input tree has errors, aborting (use -f to force output)
>> >> make[2]: *** [arch/arm/boot/dts/imx6dl-sabresd.dtb] Error 2
>> >> ERROR (phandle_references): Reference to non-existent node or label "pinctrl_usdhc4_1"
>> >>
>> >> ERROR: Input tree has errors, aborting (use -f to force output)
>> >> make[2]: *** [arch/arm/boot/dts/imx6q-sabresd.dtb] Error 2
>> >>
>> >> Caused by commit fc4fafac9656 ("ARM: dts: sabresd: add usdhc4 support").
>> >>
>> >> I have used the mmc tree from next-20131212 for today.
>> >
>> > --
>> > Cheers,
>> > Stephen Rothwell                    sfr@canb.auug.org.au
>
