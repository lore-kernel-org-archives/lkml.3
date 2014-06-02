Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbaFBSqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 14:46:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:48412 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbaFBSqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 14:46:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,958,1392192000"; 
   d="scan'208";a="541376251"
Message-ID: <538CC567.2060305@linux.intel.com>
Date: Mon, 02 Jun 2014 11:41:43 -0700
From: eric ernst <eric.ernst@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>,
        Josh Boyer <jwboyer@fedoraproject.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        mark.gross@intel.com
Subject: Re: [PATCH 1/1] Add kernel parameter for kernel version
References: <1401219641-79301-1-git-send-email-eric.ernst@linux.intel.com> <CA+5PVA5pBb1C7bQE2Od+jamEGr3=hepT-6OVsQFE7GZvU=2_yA@mail.gmail.com> <5384F034.8030303@infradead.org>
In-Reply-To: <5384F034.8030303@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 14-05-27 01:06 PM, Randy Dunlap wrote:
> On 05/27/2014 12:48 PM, Josh Boyer wrote:
>> On Tue, May 27, 2014 at 3:40 PM,  <eric.ernst@linux.intel.com> wrote:
>>> From: Eric Ernst <eric.ernst@linux.intel.com>
>>>
>>> Create a kernel cmdline parameter, "version_addendum", which can be
>>> used to add text to the kernel version that is reported from
>>> /proc/version.
>> Why?
>>
>> What is the intended purpose of this and why would someone want to use it?
> and if the patch were to continue to live, it needs a Documentation addition
> to kernel-parameters.txt.
>
Randy - ACK.

Josh - we have a need to keep a single product binary (kernel) across 
multiple android devices.  A subset of these platforms are looking for 
extra versioning information appended to it, accessible via 
/proc/version.  Rather than build multiple otherwise identical kernels 
with only this extended versioning as differentiation, we are looking to 
make this a command line parameter.  Understandable if there isn't 
enough value-add for the community in this patch, but I figured I'd give 
the patch a shot, as we need this functionality locally.  Thanks.
