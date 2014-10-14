Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbaJNNfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 09:35:55 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39347 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248AbaJNNfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 09:35:54 -0400
Message-ID: <543D26B6.9020506@codeaurora.org>
Date: Tue, 14 Oct 2014 16:35:50 +0300
From: Tanya Brokhman <tlinder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: Richard Weinberger <richard@nod.at>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] UBI: Fastmap: Care about the protection queue
References: <1412029248-22454-1-git-send-email-richard@nod.at>	 <1412029248-22454-4-git-send-email-richard@nod.at>	 <1412346676.3795.62.camel@sauron.fi.intel.com> <542EF3BF.1070401@nod.at>	 <1413206263.7906.18.camel@sauron.fi.intel.com> <543BE21F.5020504@nod.at>	 <1413213803.7906.45.camel@sauron.fi.intel.com> <543C3E60.4080507@nod.at>	 <1413282203.7906.72.camel@sauron.fi.intel.com>	 <543D1545.8090209@codeaurora.org> <1413291739.7906.88.camel@sauron.fi.intel.com>
In-Reply-To: <1413291739.7906.88.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2014 4:02 PM, Artem Bityutskiy wrote:
> On Tue, 2014-10-14 at 15:21 +0300, Tanya Brokhman wrote:
>> Hi Artem/Richard
>>
>> I think your discussion here stopped being relevant to this specific
>> patch but went on to the fastmap feature design in general :)
>> This patch fixes a real bug in the current implementation of the
>> feature. What you're discussing requires a re-writing and re-design of
>> the feature. Perhaps this one can be merged and will be "fixed" later on
>> when you agree on how you would like FM to access WL data structures in
>> general?
>
> First of all, "re-writing and re-design of the feature" is an
> overstatement. So far this is on the "cleaning things up" side of the
> spectrum, closer to the "re-factoring" area.
>
> WRT "merge the fix now and improve later" - this is a good argument for
> an "inside a company" discussion, where the primary TTM is the driving
> factor.
>
> For the community TTM is a good thing, but quality comes first.
>
> Now, if this was about a regression, one could apply time pressure on
> the maintainer. But we are talking about a problem which was there from
> day 0.
>
> It is completely normal for the maintainer to push back various
> hot-fixes for the problem and request some reasonable re-factoring
> first. This is what I do. This is very very usual thing in the Linux
> community.
>
> So far I did not ask anything huge and unreasonable, I think. Just
> cleaner inter-subsystem APIs, less of the "fastmap uses the other
> subsystems' internals" kind of things.
>
> --
> Artem.
>

Ok, accepted. It was just a suggestion. I'm all for quality coming 
first, even if you were asking for something "huge".

Thanks,
Tanya Brokhman
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
