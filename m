Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbbANAQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 19:16:38 -0500
Received: from lists.s-osg.org ([54.187.51.154]:53423 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbbANAQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 19:16:36 -0500
Message-ID: <54B5B561.40406@osg.samsung.com>
Date: Tue, 13 Jan 2015 17:16:33 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@ozlabs.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/powerpc: Add .gitignore for powerpc selftests
References: <1421192997-17003-1-git-send-email-mpe@ellerman.id.au>
In-Reply-To: <1421192997-17003-1-git-send-email-mpe@ellerman.id.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please add a commit log.

On 01/13/2015 04:49 PM, Michael Ellerman wrote:
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> ---
>  .../testing/selftests/powerpc/copyloops/.gitignore |  4 ++++
>  tools/testing/selftests/powerpc/mm/.gitignore      |  1 +
>  tools/testing/selftests/powerpc/pmu/.gitignore     |  3 +++
>  tools/testing/selftests/powerpc/pmu/ebb/.gitignore | 22 ++++++++++++++++++++++
>  .../selftests/powerpc/primitives/.gitignore        |  1 +
>  tools/testing/selftests/powerpc/tm/.gitignore      |  1 +
>  6 files changed, 32 insertions(+)
>  create mode 100644 tools/testing/selftests/powerpc/copyloops/.gitignore
>  create mode 100644 tools/testing/selftests/powerpc/mm/.gitignore
>  create mode 100644 tools/testing/selftests/powerpc/pmu/.gitignore
>  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/.gitignore
>  create mode 100644 tools/testing/selftests/powerpc/primitives/.gitignore
>  create mode 100644 tools/testing/selftests/powerpc/tm/.gitignore

Please create a single .gitignore for all targets right under
tools/testing/selftests/powerpc instead of multiple .gitignore
files.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
