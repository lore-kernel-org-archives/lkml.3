Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbaFEW3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 18:29:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42829 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbaFEW3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 18:29:41 -0400
Message-ID: <5390EF50.3010100@infradead.org>
Date: Thu, 05 Jun 2014 15:29:36 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: eric ernst <eric.ernst@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: jwboyer@fedoraproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/1] Add kernel parameter for kernel version
References: <538CC567.2060305@linux.intel.com>	<1402006157-126864-1-git-send-email-eric.ernst@linux.intel.com> <20140605151633.7dd15e8307cbd3b519ae257b@linux-foundation.org> <5390EC1B.3000706@linux.intel.com>
In-Reply-To: <5390EC1B.3000706@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2014 03:15 PM, eric ernst wrote:
> 
> On 14-06-05 03:16 PM, Andrew Morton wrote:
>> On Thu,  5 Jun 2014 15:09:17 -0700 eric.ernst@linux.intel.com wrote:
>>
>>> Create a kernel cmdline parameter, "version_addendum", which can be
>>> used to add text to the kernel version that is reported from
>>> /proc/version.
>> why?
> We have a need to keep a single product binary (kernel) across multiple android devices.  A subset of these platforms are looking for extra versioning information appended to it, accessible via /proc/version.  Rather than build multiple otherwise identical kernels with only this extended versioning as differentiation, we are looking to make this a command line parameter.  Understandable if there isn't enough value-add for the community in this patch, but I figured I'd give the patch a shot, as we need this functionality locally.  Thanks.

Please use a newline character every 70-72 characters instead of assuming
that all email programs will break that extra long line up into a readable
format.  (mine does not.)

What software needs to know the version info?  how early does it run?
Could it get the version info from 'uname -r' instead of from /proc/version?

thanks,
-- 
~Randy
