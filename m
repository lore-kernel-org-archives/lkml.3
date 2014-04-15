Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaDOImB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:42:01 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:62769 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaDOIl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:41:57 -0400
X-AuditID: cbfee690-b7f266d00000287c-98-534cf0d36707
Message-id: <534CF0D6.5030400@samsung.com>
Date: Tue, 15 Apr 2014 17:41:58 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Vikas Sajjan <sajjan.linux@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, ben-linux@fluff.org,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, sw0312.kim@samsung.com,
        hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, Olof Johansson <olof@lixom.net>,
        marc.zyngier@arm.com,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCHv2 3/8] ARM: EXYNOS: Add IO mapping for PMU of Exynos3250
References: <1397527192-21988-1-git-send-email-cw00.choi@samsung.com>
 <1397527192-21988-4-git-send-email-cw00.choi@samsung.com>
 <4788081.xvaJfdGTMu@wuerfel> <534CEEA8.6020800@samsung.com>
 <CAGm_ybhGBVmUu9PgppgWfH8b8=3JVhqK0v=ZR_yE8Cs42+VUOg@mail.gmail.com>
In-reply-to: <CAGm_ybhGBVmUu9PgppgWfH8b8=3JVhqK0v=ZR_yE8Cs42+VUOg@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42JZI2JSoHv5g0+wQU+TqMXfScfYLSatO8Bk
	cXm/tsX8I+dYLT5/aGG36F1wlc3ibNMbdotNj6+xWlzeNYfNYsb5fUwWty/zWvy984/N4tT1
	z2wWTw5/ZLWYMfklm8X6Ga9ZLI7NWMJosXfnZEYHIY8189YwerQ097B5/P41idHj76oXzB47
	Z91l97hzbQ+bx+Yl9R5XTjSxevRtWcXo8XmTXABXFJdNSmpOZllqkb5dAlfG9HOxBTv5Kiav
	3sjawHiPu4uRk0NCwERiSe8+VghbTOLCvfVsXYxcHEICSxklni7YxwRT9LylgQkisYhR4vPs
	PnYI5zWjxM7ru4AyHBy8AloSG06CTWIRUJXoXrCYDcRmAwrvf3EDzBYVCJNYOf0KC4jNKyAo
	8WPyPRaQVhEBTYmHH21ARjILXGOR+H72OSNIjbCAj8TLq+ugdrUxSaz/3geW4BQIljg/fyIz
	iM0soC4xad4iKFteYvOat8wQVx/hkHi9jA/iIAGJb5MPgS2TEJCV2HQAqkRS4uCKGywTGMVm
	ITlpFpKps5BMXcDIvIpRNLUguaA4Kb3IRK84Mbe4NC9dLzk/dxMjMB2c/vdswg7GewesDzEm
	A62cyCwlmpwPTCd5JfGGxmZGFqYmpsZG5pZmpAkrifOqPUoKEhJITyxJzU5NLUgtii8qzUkt
	PsTIxMEp1cBo9XjLxjleB5uXW/+USHtqoWrhd830yL+aR0uF177iiwtZc/eH6LILR0Ju9G/m
	6d3vLzJdzCpYTOn6+ZyOpFV3dwrzHClMM5m8r8VBpSF/T39S+MusxqrevO47a/96yu16aekV
	xB658T/fRde/m25fibv4NyKk5+jVdUdC3pq+lz7NLLbGVfKUEktxRqKhFnNRcSIACSV6Tx0D	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBKsWRmVeSWpSXmKPExsVy+t9jAd3LH3yCDd43cVv8nXSM3WLSugNM
	Fpf3a1vMP3KO1eLzhxZ2i94FV9kszja9YbfY9Pgaq8XlXXPYLGac38dkcfsyr8XfO//YLE5d
	/8xm8eTwR1aLGZNfslmsn/GaxeLYjCWMFnt3TmZ0EPJYM28No0dLcw+bx+9fkxg9/q56weyx
	c9Zddo871/aweWxeUu9x5UQTq0ffllWMHp83yQVwRTUw2mSkJqakFimk5iXnp2TmpdsqeQfH
	O8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAPaWkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC
	1zckCK7HyAANJKxhzJh+LrZgJ1/F5NUbWRsY73F3MXJySAiYSDxvaWCCsMUkLtxbz9bFyMUh
	JLCIUeLz7D52COc1o8TO67uAqjg4eAW0JDacZAVpYBFQlehesJgNxGYDCu9/cQPMFhUIk1g5
	/QoLiM0rICjxY/I9FpBWEQFNiYcfbUBGMgtcY5H4fvY5I0iNsICPxMur66B2tTFJrP/eB5bg
	FAiWOD9/IjOIzSygLjFp3iIoW15i85q3zBMYBWYh2TELSdksJGULGJlXMYqmFiQXFCel5xrp
	FSfmFpfmpesl5+duYgSnm2fSOxhXNVgcYhTgYFTi4Z3wzjtYiDWxrLgy9xCjBAezkgjvl5c+
	wUK8KYmVValF+fFFpTmpxYcYk4FBMJFZSjQ5H5gK80riDY1NzIwsjcwNLYyMzUkTVhLnPdhq
	HSgkkJ5YkpqdmlqQWgSzhYmDU6qBUU5wlYOH+ElHG5FtL86K8ReeXyAhaOitcyD5Rt/sjZPf
	KHzalGqztdber6CCU3FtzPop5ju3xu4/d8n9qpHKk/2LX+Xr1rwo2m3PHPq9wOj//Iwtk0/P
	Ui2YH8mR6Bx32fprwDOXc3fLw7ZefqUqtIv5r9AEu4W+4UWef7c5VpvI5bItkVXfrsRSnJFo
	qMVcVJwIAJAV40J7AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/15/2014 05:39 PM, Vikas Sajjan wrote:
> Hi,
> 
> On Tue, Apr 15, 2014 at 2:02 PM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> Hi,
>>
>> On 04/15/2014 05:11 PM, Arnd Bergmann wrote:
>>> On Tuesday 15 April 2014 10:59:47 Chanwoo Choi wrote:
>>>> This patch add memory mapping for PMU (Power Management Unit) which is used
>>>> for power control of Exynos3250.
>>>>
>>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>> ---
>>>> Arnd Bergmann suggested that need proper driver instead of static memory mapping.
>>>> As Chanho Park reply[2], Sachin Kamat already posted the DT support patch[1]
>>>> for memory mapping for SYSRAM.
>>>> [1] http://www.spinics.net/lists/linux-samsung-soc/msg27647.html
>>>> [2] https://lkml.org/lkml/2014/4/10/161
>>>>
>>>> So, I'm going to re-implement following patch related to static memory mapping
>>>> after merged Sachin Kamat patch[1].
>>>>   ARM: EXYNOS: Add IO mapping for PMU of Exynos3250
>>>
>>> I don't think we have a patch for the PMU yet, Sachin was looking at the SYSRAM
>>> only.
>>
>> You are right. Sachin's patch only included the solution of SYSRAM memory mapping.
>> I set out the plan that I would implment proper driver for PMU memory mapping
>> instead of static method after merged Sachin's patch for SYSRAM.
>>
>> But,
>> If you'd like me to implment PMU memory mapping instead of static mapping right now,
>> I'll implement it for PMU such as Sachin's patch on next posting(v3).
>>
> 
> I have already posted patch[1] for mapping PMU through DT as part of
> my PMU series for exynos5260.
> You can rebase on the same.
> 
> 
> [1] http://www.spinics.net/lists/arm-kernel/msg316013.html

OK, I'll rebase it after merged PMU mapping patch[1].

Thanks,
Chanwoo Choi

