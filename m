Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbaJIW3D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 18:29:03 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:37128 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaJIW3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 18:29:00 -0400
Date: Thu, 9 Oct 2014 23:28:54 +0100
From: Paul Burton <paul.burton@imgtec.com>
To: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
CC: David Daney <ddaney.cavm@gmail.com>, <linux-mips@linux-mips.org>,
        <Zubair.Kakakhel@imgtec.com>, <geert+renesas@glider.be>,
        <david.daney@cavium.com>, <peterz@infradead.org>,
        <paul.gortmaker@windriver.com>, <davidlohr@hp.com>,
        <macro@linux-mips.org>, <chenhc@lemote.com>, <richard@nod.at>,
        <zajec5@gmail.com>, <james.hogan@imgtec.com>, <keescook@chromium.org>,
        <alex@alex-smith.me.uk>, <tglx@linutronix.de>, <blogic@openwrt.org>,
        <jchandra@broadcom.com>, <qais.yousef@imgtec.com>,
        <linux-kernel@vger.kernel.org>, <ralf@linux-mips.org>,
        <markos.chandras@imgtec.com>, <dengcheng.zhu@imgtec.com>,
        <manuel.lauss@gmail.com>, <akpm@linux-foundation.org>,
        <lars.persson@axis.com>
Subject: Re: [PATCH v2 0/3] MIPS executable stack protection
Message-ID: <20141009222854.GX4704@pburton-laptop>
References: <20141009195030.31230.58695.stgit@linux-yegoshin>
 <5437015B.3010205@gmail.com>
 <543709D0.6000501@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <543709D0.6000501@imgtec.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [192.168.159.30]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 03:18:56PM -0700, Leonid Yegoshin wrote:
> >The recent discussions on this subject, including many comments from
> >Imgtec e-mail addresses, brought to light the need to use an instruction
> >set emulator for newer MIPSr6 ISA processors.
> 
> In Imgtec I am only one who works on MIPS R6 SW and FPU branch emulation and
> I say you - it is not needed, this solution is enough.

On R6, yes, for some time now but you still have not submitted that code
for review. Your having worked on something does not automatically make
it correct.

On the FP branch delays, clearly not given that I submitted a similar
patch almost a year ago...

Paul
