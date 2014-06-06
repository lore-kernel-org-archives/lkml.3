Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaFFULD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 16:11:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:45102 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbaFFULB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 16:11:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,991,1392192000"; 
   d="scan'208";a="553051251"
Message-ID: <53922054.6020108@intel.com>
Date: Fri, 06 Jun 2014 13:11:00 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: jwboyer@fedoraproject.org, Sasha Levin <sasha.levin@oracle.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: pte_present check on hugetlb_entry fix for 3.15?
References: <20140606173546.GA1869@zod>	<53920c95.685a8c0a.2111.ffffe52fSMTPIN_ADDED_BROKEN@mx.google.com> <20140606115919.df17197c7182a0f7ed59c3a9@linux-foundation.org>
In-Reply-To: <20140606115919.df17197c7182a0f7ed59c3a9@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2014 11:59 AM, Andrew Morton wrote:
> On Fri,  6 Jun 2014 14:46:37 -0400 Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:
>> On Fri, Jun 06, 2014 at 01:36:54PM -0400, Josh Boyer wrote:
>>> Hi Naoya,
>>>
>>> I noticed that your
>>> mm-add-pte_present-check-on-existing-hugetlb_entry-callbacks.patch in
>>> Andrew's -mm tree has been queued for a while and has a CC to stable on
>>> it.  Is that something that should get into 3.15?
>>
>> I'm not sure. I guess Andrew will decide this in a few days.
> 
> I was planning on doing so but then Dave popped up with an alternative
> which rather blew a hole in things.

This one patch is independent from what I was posting.  I don't think my
patch would have had any effect on the behavior this one is fixing.

IOW, don't hold it up for my (or my patches) benefit.
