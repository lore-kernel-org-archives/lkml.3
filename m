Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783AbbAIQ1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 11:27:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39373 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbbAIQ1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 11:27:41 -0500
Message-ID: <54B00175.4050702@suse.cz>
Date: Fri, 09 Jan 2015 17:27:33 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Masahiro Yamada <yamada.m@jp.panasonic.com>, linux-kbuild@vger.kernel.org
CC: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-doc@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>, Robert Richter <rrichter@cavium.com>,
        Michael Ellerman <mpe@ellerman.id.au>, Helge Deller <deller@gmx.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andi Kleen <ak@linux.intel.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 0/6] kbuild: refactor Makefiles related with cc-version
References: <1419485488-22336-1-git-send-email-yamada.m@jp.panasonic.com>
In-Reply-To: <1419485488-22336-1-git-send-email-yamada.m@jp.panasonic.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-12-25 06:31, Masahiro Yamada wrote:
> Masahiro Yamada (6):
>   kbuild: fix cc-ifversion macro
>   kbuild: do not add $(call ...) to invoke cc-version or cc-fullversion
>   kbuild,gcov: remove unnecessary workaround
>   kbuild,gcov: simplify kernel/gcov/Makefile
>   kbuild: allow cc-ifversion to have the argument for false condition
>   kbuild,gcov: simplify kernel/gcov/Makefile more

Applied to kbuild.git#kbuild, thanks.

Michal

