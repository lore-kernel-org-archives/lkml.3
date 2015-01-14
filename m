Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbbANDuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 22:50:20 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:32816 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbbANDuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 22:50:16 -0500
Message-ID: <54B5E76F.6050307@linux.vnet.ibm.com>
Date: Wed, 14 Jan 2015 09:20:07 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>,
        Shuah Khan <shuahkh@osg.samsung.com>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/powerpc: Add .gitignore for powerpc selftests
References: <1421192997-17003-1-git-send-email-mpe@ellerman.id.au> <54B5B561.40406@osg.samsung.com> <1421201759.10748.8.camel@ellerman.id.au>
In-Reply-To: <1421201759.10748.8.camel@ellerman.id.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011403-0021-0000-0000-00000354288C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2015 07:45 AM, Michael Ellerman wrote:
> On Tue, 2015-01-13 at 17:16 -0700, Shuah Khan wrote:
>> Please add a commit log.
>  
> What does it need to say?
> 
>> On 01/13/2015 04:49 PM, Michael Ellerman wrote:
>>> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>>> ---
>>>  .../testing/selftests/powerpc/copyloops/.gitignore |  4 ++++
>>>  tools/testing/selftests/powerpc/mm/.gitignore      |  1 +
>>>  tools/testing/selftests/powerpc/pmu/.gitignore     |  3 +++
>>>  tools/testing/selftests/powerpc/pmu/ebb/.gitignore | 22 ++++++++++++++++++++++
>>>  .../selftests/powerpc/primitives/.gitignore        |  1 +
>>>  tools/testing/selftests/powerpc/tm/.gitignore      |  1 +
>>>  6 files changed, 32 insertions(+)
>>>  create mode 100644 tools/testing/selftests/powerpc/copyloops/.gitignore
>>>  create mode 100644 tools/testing/selftests/powerpc/mm/.gitignore
>>>  create mode 100644 tools/testing/selftests/powerpc/pmu/.gitignore
>>>  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/.gitignore
>>>  create mode 100644 tools/testing/selftests/powerpc/primitives/.gitignore
>>>  create mode 100644 tools/testing/selftests/powerpc/tm/.gitignore
>>
>> Please create a single .gitignore for all targets right under
>> tools/testing/selftests/powerpc instead of multiple .gitignore
>> files.
> 
> Why? Having separate files makes it less likely we'll get merge conflicts
> between different test subdirectores, it also makes it more likely someone
> adding a test will notice they need to update the .gitignore in the same
> directory.

Hey Michael,

I had already posted a similar patch in this regard along with the ptrace
patches last month. Thats why I mentioned in the cover letter that
gitignore updates for all these tests will come from that patch series
instead of from this one. 

https://lkml.org/lkml/2014/12/2/80

Regards
Anshuman

