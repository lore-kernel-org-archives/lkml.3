Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab3IFWT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 18:19:59 -0400
Received: from unicorn.mansr.com ([81.2.72.234]:40150 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab3IFWT6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 18:19:58 -0400
X-Greylist: delayed 468 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Sep 2013 18:19:57 EDT
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: behanw@converseincode.com
Cc: linux@arm.linux.org.uk, Will Deacon <will.deacon@arm.com>,
        Wade Farnsworth <wade_farnsworth@mentor.com>,
        Will Drewry <wad@chromium.org>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH 1/5] arm: LLVMLinux: Add current_stack_pointer macro for ARM
References: <1378502899-1241-1-git-send-email-behanw@converseincode.com>
	<1378502899-1241-2-git-send-email-behanw@converseincode.com>
Date: Fri, 06 Sep 2013 23:12:05 +0100
In-Reply-To: <1378502899-1241-2-git-send-email-behanw@converseincode.com>
	(behanw@converseincode.com's message of "Fri, 6 Sep 2013 17:28:07
	-0400")
Message-ID: <yw1xmwnp1txm.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

behanw@converseincode.com writes:

> +#define current_stack_pointer ({ \
> +	unsigned long current_sp; \
> +	asm ("mov %0, r13" : "=r" (current_sp)); \
> +	current_sp; \
> +})

Why do you use 'r13' rather than the more common 'sp' alias?

-- 
Måns Rullgård
mans@mansr.com
