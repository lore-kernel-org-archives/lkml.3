Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab3EMGF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 02:05:27 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:37243 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab3EMGFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 02:05:23 -0400
MIME-Version: 1.0
In-Reply-To: <5176A807.2090005@samsung.com>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
	<2a5901ce31c9$95160980$bf421c80$%kim@samsung.com>
	<CAKohpokk1Q+0gRpeW=ts0a8D+rGAUpHu62X+7ejdpfom_B6FYA@mail.gmail.com>
	<1769336.FkfMpuXqqb@vostro.rjw.lan>
	<5176A807.2090005@samsung.com>
Date: Mon, 13 May 2013 11:35:22 +0530
Message-ID: <CAKohpomV9-JEbuHWdmp6N+bKYt+83hXXcqg4aKXSY1a5zwpW9Q@mail.gmail.com>
Subject: Re: [PATCH 07/18] cpufreq: s3c24xx: move cpufreq driver to drivers/cpufreq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Kukjin Kim <kgene.kim@samsung.com>
Cc: robin.randhawa@arm.com, Ben Dooks <ben-linux@fluff.org>,
        linux-pm@vger.kernel.org, patches@linaro.org, Liviu.Dudau@arm.com,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Steve.Bannister@arm.com,
        arvind.chauhan@arm.com, linaro-kernel@lists.linaro.org,
        charles.garcia-tobin@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 April 2013 20:55, Kukjin Kim <kgene.kim@samsung.com> wrote:
> On 04/05/13 20:36, Rafael J. Wysocki wrote:
>>
>> On Friday, April 05, 2013 12:36:34 PM Viresh Kumar wrote:
>>>
>>> On 5 April 2013 12:18, Kukjin Kim<kgene.kim@samsung.com>  wrote:
>>>>
>>>> Basically, this moving looks good to me, but should be re-worked based
>>>> on
>>>> for-next of samsung tree because this touches too many samsung stuff so
>>>> this
>>>> should be sent to upstream via samsung tree.
>>>
>>>
>>> Hmm... Its already applied in Rafael's tree. But it doesn't mean that
>>> it can't be
>>> moved to your tree if there is a issue.
>>
>>
>> Well, I'm dropping it.  Please merge via the Samsung tree.
>>
>
> Oops, I missed, maybe I have no more chance to send this to upstream for
> upcoming merge window :-(
>
> Rafael, please take this patch with my ack in your tree, sorry for noise.
>
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
>
> If any problems, please kindly let me know.

Who is going to pick this patch now for next merge window?
