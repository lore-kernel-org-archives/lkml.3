Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab3LJAfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 19:35:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38844 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726Ab3LJAfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 19:35:41 -0500
Message-ID: <52A66190.9060907@zytor.com>
Date: Mon, 09 Dec 2013 16:34:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
CC: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Vivek Goyal <vgoyal@redhat.com>, Rob Landley <rob@landley.net>,
        Eric Biederman <ebiederm@xmission.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        linux-doc@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH v2] kexec: add sysctl to disable kexec
References: <20131210001620.GA7938@www.outflux.net>
In-Reply-To: <20131210001620.GA7938@www.outflux.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 04:16 PM, Kees Cook wrote:
> For general-purpose (i.e. distro) kernel builds it makes sense to build with
> CONFIG_KEXEC to allow end users to choose what kind of things they want to do
> with kexec. However, in the face of trying to lock down a system with such
> a kernel, there needs to be a way to disable kexec (much like module loading
> can be disabled). Without this, it is too easy for the root user to modify
> kernel memory even when CONFIG_STRICT_DEVMEM and modules_disabled are set.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Acked-by: Rik van Riel <riel@redhat.com>

So the logic is to load a crashkernel and then lock down the machine
before services, networking etc. are enabled?

	-hpa


