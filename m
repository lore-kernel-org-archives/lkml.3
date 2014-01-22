Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaAVWXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 17:23:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43094 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbaAVWXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 17:23:43 -0500
Message-ID: <52E044E5.1090108@zytor.com>
Date: Wed, 22 Jan 2014 14:23:33 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Cohen <david.a.cohen@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
        Fei Yang <fei.yang@intel.com>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] x86: don't add new __cpuinit users to Merrifield platform
 code
References: <1390412125-19439-1-git-send-email-paul.gortmaker@windriver.com> <20140122180803.GA25171@psi-dev26.jf.intel.com> <20140122180936.GB25171@psi-dev26.jf.intel.com>
In-Reply-To: <20140122180936.GB25171@psi-dev26.jf.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2014 10:09 AM, David Cohen wrote:
> On Wed, Jan 22, 2014 at 10:08:03AM -0800, David Cohen wrote:
>> On Wed, Jan 22, 2014 at 12:35:25PM -0500, Paul Gortmaker wrote:
>>> Commit bc20aa48bbb3068224a1c91f8332971fdb689fad ("x86, intel-mid:
>>> Add Merrifield platform support")  added new instances of __cpuinit
>>> usage.  We removed this a couple versions ago; we now want to remove
>>> the compat no-op stubs.  Introducing new users is not what we want to
>>> see at this point in time, as it will break once the stubs are gone.
>>>
>>> This also fixes an out of sync __init vs. __cpuinit -- as the former
>>> is real, and the latter is a no-op; hence it would have been a section
>>> mismatch.
>>>
>>> Cc: David Cohen <david.a.cohen@linux.intel.com>
>>> Cc: Fei Yang <fei.yang@intel.com>
>>> Cc: H. Peter Anvin <hpa@linux.intel.com>
>>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>>
>> Thanks for the patch.
>>
>> Acked-by: David Cohen <david.a.cohen@linux.intel.com>
> 
> Grr... wrong acked version :)
> I'm getting back this ack.

?!  I don't see any other version?

	-hpa


