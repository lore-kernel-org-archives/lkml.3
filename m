Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab3EBFnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 01:43:06 -0400
Received: from gecko.sbs.de ([194.138.37.40]:15281 "EHLO gecko.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877Ab3EBFnB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 01:43:01 -0400
From: "Warlich, Christof" <christof.warlich@siemens.com>
To: Mikael Pettersson <mikpe@it.uu.se>
CC: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: X86 fpu registers in a signal handler's ucontext
Thread-Topic: X86 fpu registers in a signal handler's ucontext
Thread-Index: AQHORbDfqvz3Ty+ARUuGAGM8sG/3EJjxXeUg
Date: Thu, 2 May 2013 05:42:35 +0000
Message-ID: <6D83E89737156549AEA25EF9ED712C5DE3D0@DEFTHW99EK1MSX.ww902.siemens.net>
References: <6D83E89737156549AEA25EF9ED712C5DDEF7@DEFTHW99EK1MSX.ww902.siemens.net>
	<m2a9ohusmp.fsf@firstfloor.org>
	<6D83E89737156549AEA25EF9ED712C5DE0A9@DEFTHW99EK1MSX.ww902.siemens.net>
	<20863.43739.999287.287981@pilspetsen.it.uu.se>
	<6D83E89737156549AEA25EF9ED712C5DE208@DEFTHW99EK1MSX.ww902.siemens.net>
 <20863.55352.431848.272078@pilspetsen.it.uu.se>
In-Reply-To: <20863.55352.431848.272078@pilspetsen.it.uu.se>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [139.22.70.9]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson <mikpe@it.uu.se> writes:
> You're looking at the wrong header: glibc-2.17/sysdeps/i386/sys/ucontext.h is legacy SVR4.
> Instead look at glibc-2.17/sysdeps/unix/sysv/linux/x86/sys/ucontext.h.
> 
> (If the old one got installed on your system then something there is seriously wrong.)

Oh-oh: It looks like my system was simply too old: Initially, I was looking at Ubuntu 11.10
with an eglibc-2.13, and a double-check with a newly downloaded glibc-2.17 lead me to the
wrong file.

Many thanks for your help!  
   