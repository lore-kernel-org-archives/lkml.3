Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbaDYTUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 15:20:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbaDYTUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 15:20:45 -0400
Message-ID: <535AB0B5.8060305@redhat.com>
Date: Fri, 25 Apr 2014 15:00:05 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 0/3] timekeeping: Improved NOHZ frequency steering
References: <1398380677-8684-1-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1398380677-8684-1-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/24/2014 07:04 PM, John Stultz wrote:
> Continuing the sporadic work on improving the timekeeping
> frequency steering logic when NOHZ is enabled, I've made a number
> of changes to my re-implementation of Miroslav's patch (most
> recently posted here: https://lkml.org/lkml/2014/2/12/401 ),
> and I'm getting much closer results in the simulator.
> 
> Compared with Miroslav's patch, this avoids doing any extra
> divisions, and instead approximates the correction
> logarithmically. In addition to trying to lower overhead, this
> allows the other accounting bits to be managed in much the
> same way we have been doing for awhile.
> 
> This patch set contains one portion from Miroslav's patch
> (ntp_tick caching) split out into a separate logical patch.
> 
> Below are some of the simulator results (BTW Miroslav, w/ 3.15-rc,
> you'll need to revert b399fe355b30d01 to get the simulator building)
> comparing this patchset to Miroslav's patch to show we're getting in
> the right order of magnitude.
> 

John, I'm going to put this into a weekend long test right away (along with
another unrelated cpupower patch).  I'll ping back Monday to let you know how it
went.

P.
