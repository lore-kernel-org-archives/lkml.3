Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbaLBSXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 13:23:32 -0500
Received: from lists.s-osg.org ([54.187.51.154]:38944 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187AbaLBSXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:23:30 -0500
Message-ID: <547E039F.7070509@osg.samsung.com>
Date: Tue, 02 Dec 2014 11:23:27 -0700
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
        mpe@ellerman.id.au, sam.bobroff@au1.ibm.com, kirjanov@gmail.com,
        Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH V6 9/9] selftests: Make GIT ignore all binaries in powerpc
 test suite
References: <1417507013-11948-1-git-send-email-khandual@linux.vnet.ibm.com> <1417507013-11948-10-git-send-email-khandual@linux.vnet.ibm.com>
In-Reply-To: <1417507013-11948-10-git-send-email-khandual@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2014 12:56 AM, Anshuman Khandual wrote:
> This patch includes all of the powerpc test binaries into the
> .gitignore file listing in their respective directories. This
> will make sure that GIT ignores all of these test binaries while
> displaying status.
> 
> Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
> ---
>  .../testing/selftests/powerpc/copyloops/.gitignore |  4 ++++
>  tools/testing/selftests/powerpc/mm/.gitignore      |  1 +
>  tools/testing/selftests/powerpc/pmu/.gitignore     |  3 +++
>  tools/testing/selftests/powerpc/pmu/ebb/.gitignore | 22 ++++++++++++++++++++++
>  .../selftests/powerpc/primitives/.gitignore        |  1 +
>  5 files changed, 31 insertions(+)
>  create mode 100644 tools/testing/selftests/powerpc/copyloops/.gitignore
>  create mode 100644 tools/testing/selftests/powerpc/mm/.gitignore
>  create mode 100644 tools/testing/selftests/powerpc/pmu/.gitignore
>  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/.gitignore
>  create mode 100644 tools/testing/selftests/powerpc/primitives/.gitignore
> 

Creating a single .gitignore at tools/testing/selftests/powerpc will
make this simpler without having to add one .gitignore for each
directory underneath.

Thanks for taking on the task to add .gitignore for all powerpc
binaries.

-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
