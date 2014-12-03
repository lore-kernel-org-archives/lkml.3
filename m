Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339AbaLCFqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 00:46:49 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:60979 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbaLCFqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 00:46:47 -0500
Message-ID: <547EA3B0.6040309@linux.vnet.ibm.com>
Date: Wed, 03 Dec 2014 11:16:24 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Shuah Khan <shuahkh@osg.samsung.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
CC: peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de,
        james.hogan@imgtec.com, avagin@openvz.org, Paul.Clothier@imgtec.com,
        palves@redhat.com, oleg@redhat.com, dhowells@redhat.com,
        davej@redhat.com, davem@davemloft.net, mikey@neuling.org,
        benh@kernel.crashing.org, sukadev@linux.vnet.ibm.com,
        mpe@ellerman.id.au, sam.bobroff@au1.ibm.com, kirjanov@gmail.com
Subject: Re: [PATCH V6 9/9] selftests: Make GIT ignore all binaries in powerpc
 test suite
References: <1417507013-11948-1-git-send-email-khandual@linux.vnet.ibm.com> <1417507013-11948-10-git-send-email-khandual@linux.vnet.ibm.com> <547E039F.7070509@osg.samsung.com>
In-Reply-To: <547E039F.7070509@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120305-0029-0000-0000-000000BC2D74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2014 11:53 PM, Shuah Khan wrote:
> On 12/02/2014 12:56 AM, Anshuman Khandual wrote:
>> > This patch includes all of the powerpc test binaries into the
>> > .gitignore file listing in their respective directories. This
>> > will make sure that GIT ignores all of these test binaries while
>> > displaying status.
>> > 
>> > Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
>> > ---
>> >  .../testing/selftests/powerpc/copyloops/.gitignore |  4 ++++
>> >  tools/testing/selftests/powerpc/mm/.gitignore      |  1 +
>> >  tools/testing/selftests/powerpc/pmu/.gitignore     |  3 +++
>> >  tools/testing/selftests/powerpc/pmu/ebb/.gitignore | 22 ++++++++++++++++++++++
>> >  .../selftests/powerpc/primitives/.gitignore        |  1 +
>> >  5 files changed, 31 insertions(+)
>> >  create mode 100644 tools/testing/selftests/powerpc/copyloops/.gitignore
>> >  create mode 100644 tools/testing/selftests/powerpc/mm/.gitignore
>> >  create mode 100644 tools/testing/selftests/powerpc/pmu/.gitignore
>> >  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/.gitignore
>> >  create mode 100644 tools/testing/selftests/powerpc/primitives/.gitignore
>> > 
> Creating a single .gitignore at tools/testing/selftests/powerpc will
> make this simpler without having to add one .gitignore for each
> directory underneath.

Sure, will do.

> 
> Thanks for taking on the task to add .gitignore for all powerpc
> binaries.


