Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539AbaKYRGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:06:54 -0500
Received: from lists.s-osg.org ([54.187.51.154]:60594 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbaKYRGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:06:53 -0500
Message-ID: <5474B72A.7040403@osg.samsung.com>
Date: Tue, 25 Nov 2014 10:06:50 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
CC: peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de,
        james.hogan@imgtec.com, avagin@openvz.org, Paul.Clothier@imgtec.com,
        palves@redhat.com, oleg@redhat.com, dhowells@redhat.com,
        davej@redhat.com, davem@davemloft.net, mikey@neuling.org,
        benh@kernel.crashing.org, sukadev@linux.vnet.ibm.com,
        mpe@ellerman.id.au, sam.bobroff@au1.ibm.com, kirjanov@gmail.com
Subject: Re: [V5 7/7] selftests, powerpc: Add test case for TM related ptrace
 interface
References: <1416902731-22446-1-git-send-email-khandual@linux.vnet.ibm.com> <1416902731-22446-8-git-send-email-khandual@linux.vnet.ibm.com>
In-Reply-To: <1416902731-22446-8-git-send-email-khandual@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2014 01:05 AM, Anshuman Khandual wrote:
> This patch adds one more test case called 'tm-ptrace' targeting TM
> related ptrace interface. This test creates one child process to
> run some basic TM transactions and the parent process attaches the
> child to do some ptrace probing using the recently added regset
> interfaces. The parent process then compares the received values
> against the expected values to verify whether it has passed the
> given test or not.
> 
> Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
> ---
>  tools/testing/selftests/powerpc/tm/Makefile    |   2 +-
>  tools/testing/selftests/powerpc/tm/tm-ptrace.c | 542 +++++++++++++++++++++++++
>  2 files changed, 543 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/powerpc/tm/tm-ptrace.c
> 
> diff --git a/tools/testing/selftests/powerpc/tm/Makefile b/tools/testing/selftests/powerpc/tm/Makefile
> index 2cede23..71d400a 100644
> --- a/tools/testing/selftests/powerpc/tm/Makefile
> +++ b/tools/testing/selftests/powerpc/tm/Makefile
> @@ -1,4 +1,4 @@
> -PROGS := tm-resched-dscr
> +PROGS := tm-resched-dscr tm-ptrace
>  

Could you please add .gitignore for the binaries in this directory
to avoid git status including the binaries it in its output.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
