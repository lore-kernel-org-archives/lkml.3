Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab3LCTrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 14:47:39 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:33282 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab3LCTrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 14:47:33 -0500
MIME-Version: 1.0
In-Reply-To: <529E1659.2070103@wwwdotorg.org>
References: <20131128141826.GW26617@tbergstrom-lnx.Nvidia.com> <529E1659.2070103@wwwdotorg.org>
From: Mike Turquette <mturquette@linaro.org>
Date: Tue, 3 Dec 2013 11:47:11 -0800
Message-ID: <CAPtuhTj4Lfo1_oHj5uvmdJc360Y2C9uXe0nsMnw7ptaCJB=f-A@mail.gmail.com>
Subject: Re: pull request for clk-tegra-next
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 3, 2013 at 9:35 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 11/28/2013 07:18 AM, Peter De Schrijver wrote:
>> The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:
>>
>>   Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)
>>
>> are available in the git repository at:
>>   git://nv-tegra.nvidia.com/user/pdeschrijver/linux.git clk-tegra-next
>
> Mike, this series is a dependency for my patch series that converts
> Tegra drivers to use the standard module reset API rather than a custom
> API (which is implemented in the clock driver). If you could either
> merge this pull request, or at least ack that it's OK for me to merge it
> into the Tegra tree as a dependency, that'd be helpful. Thanks.

Hi Stephen,

I'm catching up on pull requests after a week off for Thanksgiving
holiday in the US. This looks good to me and I'll have it pulled in
later today.

Regards,
Mike
