Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab3LKRxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 12:53:07 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:46968 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab3LKRxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 12:53:05 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Vivek Goyal <vgoyal@redhat.com>, Rob Landley <rob@landley.net>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, linux-doc@vger.kernel.org,
        kexec@lists.infradead.org
References: <20131210001620.GA7938@www.outflux.net>
Date: Wed, 11 Dec 2013 09:52:55 -0800
In-Reply-To: <20131210001620.GA7938@www.outflux.net> (Kees Cook's message of
	"Mon, 9 Dec 2013 16:16:20 -0800")
Message-ID: <87vbyvxojs.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19PDSzG0VNGXg4hemhlfqdJLqRBTYh6ckM=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4178]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kees Cook <keescook@chromium.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v2] kexec: add sysctl to disable kexec
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> For general-purpose (i.e. distro) kernel builds it makes sense to build with
> CONFIG_KEXEC to allow end users to choose what kind of things they want to do
> with kexec. However, in the face of trying to lock down a system with such
> a kernel, there needs to be a way to disable kexec (much like module loading
> can be disabled). Without this, it is too easy for the root user to modify
> kernel memory even when CONFIG_STRICT_DEVMEM and modules_disabled are
> set.

So let me get this straight.  You object to what happens in sys_reboot
so you patch sys_kexec_load?

You give someone the privilege to boot whatever they want and yet you
don't want to support them booting whatever they want?

I'm sorry my brain is hurting trying to understand the logic of this
patch.

Eric
