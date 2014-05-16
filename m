Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029AbaEPKux (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 06:50:53 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:19513 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756740AbaEPKuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 06:50:51 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-84-5375ed86d3ec
Message-id: <5375ED80.2010008@samsung.com>
Date: Fri, 16 May 2014 12:50:40 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Rahul Sharma <rahul.sharma@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        PANKAJ KUMAR DUBEY <pankaj.dubey@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        sunil joshi <joshi@samsung.com>, Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH v3 1/3] phy: Add exynos-simple-phy driver
References: <1400095043-685-1-git-send-email-rahul.sharma@samsung.com>
 <1400095043-685-2-git-send-email-rahul.sharma@samsung.com>
 <5373CBAD.2010505@gmail.com>
 <CAPdUM4MT0nZcLRtNcKRAeW4Q3n5z9n4BnzR-7uYMb1gqwEhWXA@mail.gmail.com>
 <53753527.3000905@gmail.com>
 <CAPdUM4M5k-aouSA=dyUXWOyFLBhob+o8103a=gAxo-O68i-MCw@mail.gmail.com>
 <CAPdUM4Py4r3ZV79ULcJ3KojaPQ0hfZTE2XbsY+=hP4LD70mb8Q@mail.gmail.com>
In-reply-to: <CAPdUM4Py4r3ZV79ULcJ3KojaPQ0hfZTE2XbsY+=hP4LD70mb8Q@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42I5/e/4Zd22t6XBBo9uilvcWneO1WL+ESBx
	5et7NosDf3YwWnzf9YXdonfBVTaLC0972CzONr1ht7i8aw6bxYzz+5gsFm0Fyk5ZdJjVonXv
	EXaLeZ93MlnMa3/JarFq1x9GBwGPnbPusntsWtXJ5nHn2h42j/vdx5k8+rasYvQ4fmM7k8fn
	TXIB7FFcNimpOZllqUX6dglcGX8nmhXMEau4u2klUwPjQsEuRg4OCQETifm92V2MnECmmMSF
	e+vZuhi5OIQEljJKnF2yhRXC+cwoce/NXhaQKl4BLYmVT4+xgtgsAqoS97dcYwex2QTUJD43
	PGIDsfmBatY0XWcBWSAqECHx+IIQRKugxI/J98DGiAgESLzsbGEEmc8ssJxVYu+0DrA5wgK2
	En3vlrBALJ7GLLF38nZmkASnQLDEhmMLmEBsZgEdif2t09ggbHmJzWveMk9gFJyFZMksJGWz
	kJQtYGRexSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRESa193MC49ZnWIUYCDUYmHlyG0NFiI
	NbGsuDL3EKMEB7OSCK/bK6AQb0piZVVqUX58UWlOavEhRiYOTqkGxrX8h5iWM1RqhP/dItF0
	5fO+yk83eFYLrrnQebvjv4XnzhD7VW+3OrLtuVZ1f6b4gYDzVQILrR64RQWK5rVtXG+7ned1
	XH9y1CIOc+5Z701Wss/5sO/KfF2Tj/9V7G5srnh9w+kGd9adlrT+CcsClp076a/yNXTKlaRg
	BrbGe8FPxG/f8++YZK/EUpyRaKjFXFScCACTNiNlkwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.05.2014 12:35, Rahul Sharma wrote:
> On 16 May 2014 15:12, Rahul Sharma <rahul.sharma@samsung.com> wrote:
>> On 16 May 2014 03:14, Tomasz Figa <tomasz.figa@gmail.com> wrote:
>>> On 15.05.2014 06:01, Rahul Sharma wrote:
> [snip]
>>>>> the PHY provider.
>>>>>
>>>>
>>>> Please correct me if I got you wrong. You want somthing like this:
>>>>
>>>> pmu_system_controller: system-controller@10040000 {
>>>>          ...
>>>>           simple_phys: simple-phys {
>>>>                         compatible = "samsung,exynos5420-simple-phy";
>>>>                         ...
>>>>           };
>>>> };
>>>
>>> Not exactly.
>>>
>>> What I meant is that the PMU node itself should be the PHY provider, e.g.
>>>
>>> pmu_system_controller: system-controller@10040000 {
>>>         /* ... */
>>>         #phy-cells = <1>;
>>> };
>>>
>>> and then the PMU node should instantiate the Exynos simple PHY driver,
>>> as this is a driver for a facility existing entirely inside of the PMU.
>>> Moreover, the driver should be rather called Exynos PMU PHY.
>>>
>>> I know this isn't really possible at the moment, but with device tree we
>>> must design things carefully, so it's better to take a bit more time and
>>> do things properly.
>>>
>>> So my opinion on this is that there should be a central Exynos PMU
>>> driver that claims the IO region and instantiates necessary subdrivers,
>>> such as Exynos PMU PHY driver, Exynos CLKOUT driver, Exynos cpuidle
>>> driver and more, similar to what is being done in drivers/mfd.
>>
> 
> Hi Tomasz,
> 
> These PHYs are not part of PMU as such. I am not sure if it is correct to
> probe them as phy provider for all these phys. Only relation of these phys with
> the PMU is 'enable/disable control'.

Well, in reality what is implemented by this driver is not even a PHY,
just some kind of power controllers, which are contained entirely in the
PMU.

> Controlling this bit using regmap interface
> still looks better to me.

Well, when there is a choice between using regmap and not using regmap,
I'd rather choose the latter. Why would you want to introduce additional
abstraction layer if there is no need for such?

> 
> IMHO Ideal method would be probing these PHYs independently and resolving
> the necessary dependencies like syscon handle, clocks etc. This way we will
> not be having any common phy provider for all these independent PHYs and it
> would be clean to add each of these phy nodes in DT. Please see my original
> comment below.
> 
> http://lkml.iu.edu/hypermail/linux/kernel/1404.1/00701.html

With the solution I proposed, you don't need any kind of dependencies
for those simple power controllers. They are just single bits that don't
need anything special to operate, except PMU clock running.

Best regards,
Tomasz
