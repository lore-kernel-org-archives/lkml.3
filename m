Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbaGILYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:24:24 -0400
Received: from mout.gmx.net ([212.227.17.21]:61027 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739AbaGILYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:24:23 -0400
From: Jan-Simon =?ISO-8859-1?Q?M=F6ller?= <dl9pf@gmx.de>
To: Will Deacon <will.deacon@arm.com>
Cc: "behanw@converseincode.com" <behanw@converseincode.com>,
        "anurag19aggarwal@gmail.com" <anurag19aggarwal@gmail.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "charlebm@gmail.com" <charlebm@gmail.com>,
        "dave.long@linaro.org" <dave.long@linaro.org>,
        "k.khlebnikov@samsung.com" <k.khlebnikov@samsung.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linyongting@gmail.com" <linyongting@gmail.com>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rabin@rab.in" <rabin@rab.in>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Subject: Re: [PATCH 0/6] LLVMLinux: Patches to enable the kernel to be compiled with clang/LLVM
Date: Wed, 09 Jul 2014 13:24:04 +0200
Message-ID: <1485533.R9kdQa9l1r@aragorn>
User-Agent: KMail/4.13.2 (Linux/3.11.10-7-desktop; KDE/4.13.2; x86_64; ; )
In-Reply-To: <20140709095718.GD9485@arm.com>
References: <1404850576-2006-1-git-send-email-behanw@converseincode.com> <20140709095718.GD9485@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:cR4uAPFN7fjsKAsJyp0MvhRGqL+QAtQDx0z3xf1ola+QQWD4hKw
 JDIQYMcU5RKRq/5vtkVPYQ1yFxeRgslX0RHsTfJJa5mSgE1XKIxUwpnqXPmw4rQPrDrDqu4
 3kbqHtRQ2U8tU1kwEOjCCOlcBITmhk7/OcFBWulb09hYov1n1TTAf5veNj85q9ocnV/oI0O
 3SQkJH+AQt+hLtssEUkpg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,


> BTW, have you tried building an arm64 kernel with clang?

ragarding arm64: yes, there is a test target already - see  
http://git.linuxfoundation.org/?p=llvmlinux.git;a=tree;f=targets/vexpress64

Reproduce with:
git clone http://git.linuxfoundation.org/llvmlinux.git
cd llvmlinux/targets/vexpress64
make


Best,
Jan-Simon


