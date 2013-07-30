Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694Ab3G3Jir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:38:47 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:44887 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932646Ab3G3Jic convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:38:32 -0400
Date: Tue, 30 Jul 2013 11:38:53 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Dave Martin <Dave.Martin@arm.com>
Cc: Jed Davis <jld@mozilla.com>, Robert Richter <rric@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Russell King <linux@arm.linux.org.uk>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: Fix r7/r11 confusion when CONFIG_THUMB2_KERNEL=y
 [OT]
Message-ID: <20130730113853.46cbb00a@armhf>
In-Reply-To: <20130730092517.GB2478@localhost.localdomain>
References: <1373685501-1620-1-git-send-email-jld@mozilla.com>
	<20130715135420.GG10000@mudshark.cambridge.arm.com>
	<20130720044655.GC9433@mozilla.com>
	<20130721213753.GA29879@mudshark.cambridge.arm.com>
	<20130722185234.GA14519@localhost.localdomain>
	<20130729212140.GB12681@mozilla.com>
	<20130730092517.GB2478@localhost.localdomain>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jul 2013 10:25:18 +0100
Dave Martin <Dave.Martin@arm.com> wrote:

> The pragmatic route is less contraversial and lower overhead: even though
> it's not correct as per the ABI, GCC is the only supported compiler for
> building the kernel anyway.

BTW, kernels compiled with gcc-4.8 don't work.

Did anybody succeed with clang?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
