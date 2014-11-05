Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbaKEKXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:23:48 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:8430 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbaKEKXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:23:45 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-79-5459faae938e
Message-id: <5459FAA8.1060902@samsung.com>
Date: Wed, 05 Nov 2014 11:23:36 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>, Greg KH <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        jg1.han@samsung.com, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v3] usb: Remove references to non-existent PLAT_S5P symbol
References: <1412673127-11479-1-git-send-email-s.nawrocki@samsung.com>
 <20141103232438.GA11698@kroah.com> <54591BDF.8060203@samsung.com>
 <1415128864.20372.189.camel@x220> <20141104194221.GB3722@kroah.com>
 <1415130776.20372.194.camel@x220>
In-reply-to: <1415130776.20372.194.camel@x220>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsVy+t/xq7rrfkWGGBx4qmDRvHg9m8XlhZdY
	LS7vmsNmMeP8PiaLRctamS0W3TrD7MDmsX/uGnaPvi2rGD02bn/C5PF5k1wASxSXTUpqTmZZ
	apG+XQJXxqu9dgXP2Cpaf79naWDcyNrFyMkhIWAi0XzqMSOELSZx4d56NhBbSGApo8Ts3/5d
	jFxA9idGiXmty1hAErwCWhJ/H78Ha2YRUJXYvO4JWDObgKFE79E+MFtUIELi5N097BD1ghI/
	Jt8D6xUR8JQ40ngELM4sUCpxZ913MFtYwE/iQM8uFohlXxglNs3qB7uCU0BP4sWbLiCbA6hB
	XWLKlFyIXnmJzWveMk9gFJiFZMUshKpZSKoWMDKvYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/d
	xAgJ5i87GBcfszrEKMDBqMTD69EUGSLEmlhWXJl7iFGCg1lJhFf5M1CINyWxsiq1KD++qDQn
	tfgQIxMHp1QDI5cs96081ck+1T6sUT18t/akHFwSrbpr/sov4WeTWgKmdspvqf2XfaB+5Q+d
	P08vsnVwu94QUFqbXCOos6xU6n7vtse5cS6eN+7tTU6rLJN+mBngpWaY5ZrD3L30sNQujT79
	tL+Mec0blsUK8FbdPynaHe//26RvWpi7xYb6ZVI8JVIvg6OUWIozEg21mIuKEwFzRrJlRAIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/14 20:52, Paul Bolle wrote:
> On Tue, 2014-11-04 at 11:42 -0800, Greg KH wrote:
>> > As it's something that no one seemed to ever need before (i.e. it's not
>> > a regression fix), but it would be a "new feature", I don't think it's
>> > really a stable fix.
>> > 
>> > But feel free to convince me otherwise :)
>
> Sylwester, was I right in thinking that users of PLAT_S5P, who could set
> USB_EHCI_EXYNOS or USB_OHCI_EXYNOS pre v3.17, got, well, transferred to
> ARCH_S5PV210 and lost the ability to set one of those symbols in v3.17?

Yes, after commit d78c16ccde96 ("ARM: SAMSUNG: Remove remaining legacy code")
we lost the ability to enable USB OHCI and EHCI on S5PV210 SoC.
Thus for those who use the mainline kernel (might be rare) with S5PV210 SoC
there is obviously a regression in USB subsystem in v3.17.


-- 
Regards,
Sylwester
