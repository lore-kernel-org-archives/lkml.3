Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab3AROPf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 09:15:35 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:57519 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab3AROPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 09:15:34 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH v2 10/76] ARC: Fundamental ARCH data-types/defines
Date: Fri, 18 Jan 2013 14:15:24 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonas Bonn <jonas.bonn@gmail.com>
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-11-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1358511930-7424-11-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301181415.25145.arnd@arndb.de>
X-Provags-ID: V02:K0:fXqwSa08rPqYzLR8ikHBp11VrD+eUUrZPEhD70pMOx8
 VA3R5s57aYSpdAxssoKKk0kgYJxzPawfT71XWprwgByAvFYU97
 g4+W5kFn6rgZpuQz/LWeZKiu4lQOxN26CIhyQnb7ptA0yhcx5L
 xO0SIHFGuRDunSB191wZaKgT+3amnfWrhyPk9YM0Fae0AQxEdU
 ihEkxEbqE7Q5Huc2SWfTIZHmTfp+NwInxOiEkcmW0UE+N1wja1
 oWwuaECvdLtet2wbnjIrqM3oPXur+veMW7l8xwr8IZZQQvAS+0
 m2G0GafpAN4R3aIbIQPPY1wvT2fMw4RqnZp+hnF7DBRzqVQEtG
 FynKxZjqbLvs02aSM9go=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2013, Vineet Gupta wrote:
> * L1_CACHE_SHIFT
> * PAGE_SIZE, PAGE_OFFSET
> * struct pt_regs, struct user_regs_struct
> * struct thread_struct, cpu_relax(), task_pt_regs(), start_thread(), ...
> * struct thread_info, THREAD_SIZE, INIT_THREAD_INFO(), TIF_*, ...
> * BUG()
> * ELF_*
> * Elf_*
> 
> To disallow user-space visibility into some of the core kernel data-types
> such as struct pt_regs, #ifdef __KERNEL__ which also makes the UAPI header
> spit (further patch in the series) to NOT export it to asm/uapi/ptrace.h
> 
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> Cc: Jonas Bonn <jonas.bonn@gmail.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
