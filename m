Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab3C1BDD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 21:03:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:19764 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960Ab3C1BDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 21:03:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,922,1355126400"; 
   d="scan'208";a="276924709"
Message-ID: <515396B7.1060909@intel.com>
Date: Thu, 28 Mar 2013 09:02:47 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Yinghai Lu <yinghai@kernel.org>, Len Brown <len.brown@intel.com>,
        Changlong Xie <changlongx.xie@intel.com>, linux-acpi@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>, lkp@linux.intel.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [LKP] Commit ac3ebafa81a makes NHM EX/EP machines hung out since
 3.9-rc1
References: <20130313022759.GA120840@bee> <5152781B.6060603@intel.com> <CAE9FiQUnXev4Q+B1Cww-bhZM8O7bhbvOT=Y5c4SOjFksq1oXEw@mail.gmail.com> <15175142.3Xo9lEvds6@vostro.rjw.lan>
In-Reply-To: <15175142.3Xo9lEvds6@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2013 08:40 AM, Rafael J. Wysocki wrote:
>> > 
>> > It fixes the problem on my 8 sockets Nehalem-EX that will hang around
>> > ip_auto_config()
>> > 
>> > Tested-by: Yinghai Lu <yinghai@kernel.org>
>> > 
>> > Rafael,
>> > Can you please push this one to Linus tree ?
>> > As the offending patch was via your tree to upstream.
> I will if there's no better way to address this issue before -rc6.

If it can be pushed to upstream, please add:

Reported-by: LKP project <lkp@linux.intel.com>
Reported-by: Xie ChanglongX <changlongx.xie@intel.com>
-- 
Thanks Alex
