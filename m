Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbaFEW6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 18:58:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:53337 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119AbaFEW6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 18:58:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,984,1392192000"; 
   d="scan'208";a="523441759"
Message-ID: <5390F5A8.2010202@linux.intel.com>
Date: Thu, 05 Jun 2014 15:56:40 -0700
From: eric ernst <eric.ernst@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: jwboyer@fedoraproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/1] Add kernel parameter for kernel version
References: <538CC567.2060305@linux.intel.com>	<1402006157-126864-1-git-send-email-eric.ernst@linux.intel.com> <20140605151633.7dd15e8307cbd3b519ae257b@linux-foundation.org> <5390EC1B.3000706@linux.intel.com> <5390EF50.3010100@infradead.org>
In-Reply-To: <5390EF50.3010100@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 14-06-05 03:29 PM, Randy Dunlap wrote:
> On 06/05/2014 03:15 PM, eric ernst wrote:
>> On 14-06-05 03:16 PM, Andrew Morton wrote:
>>> On Thu,  5 Jun 2014 15:09:17 -0700 eric.ernst@linux.intel.com wrote:
>>>
>>>> Create a kernel cmdline parameter, "version_addendum", which can be
>>>> used to add text to the kernel version that is reported from
>>>> /proc/version.
>>> why?
>> We have a need to keep a single product binary (kernel) across multiple android devices.  A subset of these platforms are looking for extra versioning information appended to it, accessible via /proc/version.  Rather than build multiple otherwise identical kernels with only this extended versioning as differentiation, we are looking to make this a command line parameter.  Understandable if there isn't enough value-add for the community in this patch, but I figured I'd give the patch a shot, as we need this functionality locally.  Thanks.
> Please use a newline character every 70-72 characters instead of assuming
> that all email programs will break that extra long line up into a readable
> format.  (mine does not.)
Ack - sorry Randy - it was a quick cp / paste from earlier in the thread.
>
> What software needs to know the version info?  how early does it run?
> Could it get the version info from 'uname -r' instead of from /proc/version?
>
> thanks,
This'll end up being used by a third party customer for tracking 
particular devices, so I'm sure "much, much later" in user space. While 
I'm sure they could use uname instead, the specific request was for 
/proc/version.

The more I look into this patch, the more I think this is a pretty 
specific use case that probably doesn't have a lot of community 
value-add outside of our scenario.  Thanks for the feedback.
