Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab3DWP0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:26:11 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:38494 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762Ab3DWP0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:26:07 -0400
Message-ID: <5176A807.2090005@samsung.com>
Date: Wed, 24 Apr 2013 00:25:59 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Viresh Kumar <viresh.kumar@linaro.org>, robin.randhawa@arm.com,
        Ben Dooks <ben-linux@fluff.org>, linux-pm@vger.kernel.org,
        patches@linaro.org, Liviu.Dudau@arm.com, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org, Steve.Bannister@arm.com,
        arvind.chauhan@arm.com, linaro-kernel@lists.linaro.org,
        charles.garcia-tobin@arm.com
Subject: Re: [PATCH 07/18] cpufreq: s3c24xx: move cpufreq driver to drivers/cpufreq
References: <cover.1365079581.git.viresh.kumar@linaro.org> <2a5901ce31c9$95160980$bf421c80$%kim@samsung.com> <CAKohpokk1Q+0gRpeW=ts0a8D+rGAUpHu62X+7ejdpfom_B6FYA@mail.gmail.com> <1769336.FkfMpuXqqb@vostro.rjw.lan>
In-Reply-To: <1769336.FkfMpuXqqb@vostro.rjw.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/13 20:36, Rafael J. Wysocki wrote:
> On Friday, April 05, 2013 12:36:34 PM Viresh Kumar wrote:
>> On 5 April 2013 12:18, Kukjin Kim<kgene.kim@samsung.com>  wrote:
>>> Basically, this moving looks good to me, but should be re-worked based on
>>> for-next of samsung tree because this touches too many samsung stuff so this
>>> should be sent to upstream via samsung tree.
>>
>> Hmm... Its already applied in Rafael's tree. But it doesn't mean that
>> it can't be
>> moved to your tree if there is a issue.
>
> Well, I'm dropping it.  Please merge via the Samsung tree.
>

Oops, I missed, maybe I have no more chance to send this to upstream for 
upcoming merge window :-(

Rafael, please take this patch with my ack in your tree, sorry for noise.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

If any problems, please kindly let me know.

Thanks.

- Kukjin
