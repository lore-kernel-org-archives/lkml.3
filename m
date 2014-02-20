Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbaBTLNF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 06:13:05 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:58170 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbaBTLNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 06:13:02 -0500
MIME-Version: 1.0
In-Reply-To: <20140220105540.GB3745@pek-khao-d1.corp.ad.wrs.com>
References: <1392819290-1044-1-git-send-email-grant.likely@linaro.org>
	<CAK9yfHwwmZkFMRvxsxjBAfUbVXU3V+iPFDZO=DwQsFvJ3NQyKA@mail.gmail.com>
	<20140220101240.GA3745@pek-khao-d1.corp.ad.wrs.com>
	<CAK9yfHzM_kyXMrnLC=M0qiLHKWxE41E-MdyGtipKA7AwoLnOqg@mail.gmail.com>
	<20140220105540.GB3745@pek-khao-d1.corp.ad.wrs.com>
Date: Thu, 20 Feb 2014 16:43:01 +0530
Message-ID: <CAK9yfHwC28zUY7jzJnR3evoevPE4SBofrd0p2B=J5XOKPXzHCg@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] Bugfix for of_match_node ordering
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Kevin Hao <haokexin@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 February 2014 16:25, Kevin Hao <haokexin@gmail.com> wrote:
> On Thu, Feb 20, 2014 at 03:57:07PM +0530, Sachin Kamat wrote:
>> Hi Kevin,
>>
>> On 20 February 2014 15:42, Kevin Hao <haokexin@gmail.com> wrote:
>> > On Thu, Feb 20, 2014 at 02:09:08PM +0530, Sachin Kamat wrote:
>> >> Hi Grant,
>> >>
>> >> I observe the following boot failure with today's (next-20140220) linux-next
>> >> tree on Exynos based boards with the default exynos_defconfig.
>> >
>> > Does this help?
>>
>> The below patch works for me. Thanks for the fix.
>
> Thanks Sachin.
>
> Hi Grant,
>
> I assume you would fold this change into the original patch. But if you want
> a separate patch, please let me know.
>
> Thanks,
> Kevin

FWIW, On Exynos platform
Tested-by: Sachin Kamat <sachin.kamat@linaro.org>


-- 
With warm regards,
Sachin
