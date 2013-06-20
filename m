Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935526Ab3FTBwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 21:52:08 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:16183 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935237Ab3FTBwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 21:52:05 -0400
X-AuditID: cbfee691-b7fef6d000002d62-75-51c2603ed7b7
Message-id: <51C26049.10703@samsung.com>
Date: Thu, 20 Jun 2013 10:52:09 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510
 Thunderbird/17.0.6
MIME-version: 1.0
To: Doug Anderson <dianders@chromium.org>
Cc: Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        Olof Johansson <olof@lixom.net>,
        Andrew Bresticker <abrestic@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Will Newton <will.newton@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH v2 2/2] mmc: dw_mmc: Add the ability to set the ciu clock
 frequency
References: <1370580406-10254-1-git-send-email-dianders@chromium.org>
 <1370626110-1731-1-git-send-email-dianders@chromium.org>
 <1370626110-1731-2-git-send-email-dianders@chromium.org>
 <51BFE754.6000909@samsung.com>
 <CAD=FV=Wy5X9C=NOUVyAzZK5+BKD1w4FTmoTHzKipq2j_Y9rdtg@mail.gmail.com>
In-reply-to: <CAD=FV=Wy5X9C=NOUVyAzZK5+BKD1w4FTmoTHzKipq2j_Y9rdtg@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42JZI2JSpGuXcCjQ4M9TNovHaxYzWax8/5fR
	4sG8bWwW219vZLM4MPshq8XZZQeBrD87GC1u/GpjtVjYtoTF4vKuOWwWR/73M1o8nXCRzeLU
	9c9sFodXHGCyWPdyOovFh/sXmS1W7frDaLFw0yE2ByGPBZ+vsHvMbrjI4rFz1l12j1erZ7J6
	HLqyltHjzrU9bB7nZyxk9LhyoonVo2/LKkaPz5vkAriiuGxSUnMyy1KL9O0SuDImrNzDWLBI
	sGLrPZMGxse8XYycHBICJhL7Xx5jgbDFJC7cW8/WxcjFISSwlFHi3N/LzDBFu3auYoFILGKU
	uHP4ETtIQkjgJaPEzFdGIDavgIbEyp4dYHEWAVWJtzung9lsAjoS278dZwKxRQXCJDb1NDNB
	1AtK/Jh8D2yziICmxLOGl8wgC5gFHrBKrJ3yACwhLBApsWvaMmaIzYuZJBp6PrGCJDgFgiXm
	zl/OBmIzA23Y3zoNypaX2LzmLViDhMAJDomH3a+YIU4SkPg2+RDQVA6ghKzEpgNQr0lKHFxx
	g2UCo9gsJEfNQjJ2FpKxCxiZVzGKphYkFxQnpReZ6hUn5haX5qXrJefnbmIEJobT/55N3MF4
	/4D1IcZkoJUTmaVEk/OBiSWvJN7Q2MzIwtTE1NjI3NKMNGElcV71FutAIYH0xJLU7NTUgtSi
	+KLSnNTiQ4xMHJxSDYyFB+OiJr8qYwmfulFrYurrDYqRqxaxW3L++cO2V+nO/N4bvnsjTzyr
	3F1qefJXBBenp9pd9oXf1//ll9xauGnjg4Cg6SwBBzs3Rf1XSNxhxfz5hA+r3J39R9ad/tmz
	+HA4h7mN4KmHIhff8h2Nilmvysu01tdxz+Zq70P8VZ0JHac8z3YpzrBWYinOSDTUYi4qTgQA
	59CW9yIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDKsWRmVeSWpSXmKPExsVy+t9jAV3bhEOBBrOvWFk8XrOYyWLl+7+M
	Fg/mbWOz2P56I5vFgdkPWS3OLjsIZP3ZwWhx41cbq8XCtiUsFpd3zWGzOPK/n9Hi6YSLbBan
	rn9mszi84gCTxbqX01ksPty/yGyxatcfRouFmw6xOQh5LPh8hd1jdsNFFo+ds+6ye7xaPZPV
	49CVtYwed67tYfM4P2Mho8eVE02sHn1bVjF6fN4kF8AV1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0l5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsIYxY8LKPYwFiwQrtt4zaWB8zNvFyMkhIWAisWvnKhYIW0ziwr31bF2M
	XBxCAosYJe4cfsQOkhASeMkoMfOVEYjNK6AhsbJnB1icRUBV4u3O6WA2m4COxPZvx5lAbFGB
	MIlNPc1MEPWCEj8m3wNbICKgKfGs4SUzyAJmgQesEmunPABLCAtESuyatowZYvNiJomGnk+s
	IAlOgWCJufOXs4HYzEAb9rdOg7LlJTavecs8gVFgFpIls5CUzUJStoCReRWjaGpBckFxUnqu
	oV5xYm5xaV66XnJ+7iZGcNp5JrWDcWWDxSFGAQ5GJR5ejcsHA4VYE8uKK3MPMUpwMCuJ8M6T
	OBQoxJuSWFmVWpQfX1Sak1p8iDEZGAYTmaVEk/OBKTGvJN7Q2MTMyNLI3NDCyNicNGElcd4D
	rdaBQgLpiSWp2ampBalFMFuYODilGhjlPkypD9l14EqnYtybyPvJLJG3H7kYpdVfNl7HHBOS
	rPWvYce/LYWBCYdm1ssrfCpVn2Th5Tl9wvRP3J/8xXhWNT5QfDT/3YTemCXPQtrCndc+5moM
	jDHwdWgUFJ/RtPf1lo8TJt69cWqvfsW2391u/TZ/X0g8YhKw3/yJ/VLycZeZ8ks4ZPYosRRn
	JBpqMRcVJwIA1ZQWNH8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

I'm researching for fixed-rate-clocks.
Maybe i misunderstood for using <fixed-rate-clocks>. :)

Best Regards,
Jaehoon Chung

On 06/19/2013 12:15 AM, Doug Anderson wrote:
> Jaehoon,
> 
> On Mon, Jun 17, 2013 at 9:51 PM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
>> Hi Doug,
>>
>> I have one question for using <clock-frequency>.
>> I found the fixed-rate-clocks feature.
>> If we want to set <clock-frequency>, then can we use the fixed-rate-clocks?
>> i'm not sure how use the fixed-rate-clocks. but it seems to set fixed-rate value for clock frequency.
>>
>> clk_set_rate() didn't ensure to set the <clock-frequency> value.
> 
> I'm not sure I understand the question.  I don't think that the
> fixed-rate-clocks have a close relation to the clock-frequency or the
> ciu clock.  The fixed-rate-clock entries for a board usually specify
> the root clock source for a board.  For instance in exynos5250-snow
> you can see:
> 
> fixed-rate-clocks {
>   xxti {
>     compatible = "samsung,clock-xxti";
>     clock-frequency = <24000000>;
>   };
> };
> 
> Other clocks in the board are derived from this clock through PLLs,
> muxes, dividers, gates, etc.  On 5250 we have:
> 
>  fin_pll (xxti) -> fout_mpll -> fout_mplldiv2 -> mout_mpll_fout ->
>  sclk_mpll -> sclk_mpll_user -> mout_mmc1 -> div_mmc1
>  div_mmc_pre1 -> sclk_mmc1
> 
> In 5250 the ciu clock for mmc1 is sclk_mmc1, which is a simple gate.
> When you "enable" this clock it, ungates it.  The sclk_mmc1 has the
> flag CLK_SET_RATE_PARENT on it.  That means when you try to set the
> rate it will involve the parent clock (div_mmc_pre1).  The parent
> clock also has CLK_SET_RATE_PARENT, so it can also involve div_mmc1.
> I haven't dug through to see how the clock framework splits up divides
> between div_mmc1 and div_mmc_pre1, but it's supposed to handle that.
> 
> We don't allow clk_set_rate to percolate any higher (no
> CLK_SET_RATE_PARENT at mout_mmc1).
> 
> -Doug
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

