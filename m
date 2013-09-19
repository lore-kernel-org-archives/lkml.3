Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab3ISJg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 05:36:57 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51300 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751157Ab3ISJg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 05:36:56 -0400
Date: Thu, 19 Sep 2013 10:36:28 +0100
From: Will Deacon <will.deacon@arm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: 3.12-rc1: no longer compiles for Nokia n900 (omap based)
Message-ID: <20130919093627.GB24866@mudshark.cambridge.arm.com>
References: <20130919093002.GA23806@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130919093002.GA23806@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 10:30:02AM +0100, Pavel Machek wrote:
> Hi!
> 
> I get:
> 
>   CC      arch/arm/kernel/machine_kexec.o
> /tmp/ccCFXeXG.s: Assembler messages:
> /tmp/ccCFXeXG.s:217: Error: garbage following instruction -- `dsb
> nshst'
> /tmp/ccCFXeXG.s:225: Error: garbage following instruction -- `dsb nsh'
> make[1]: *** [arch/arm/kernel/suspend.o] Error 1
> make[1]: *** Waiting for unfinished jobs....
> 
> pavel@amd:/data/l/linux-n900$ arm-linux-gnueabi-gcc --version
> arm-linux-gnueabi-gcc (Debian 4.3.5-4) 4.3.5
> 
> Minimum required gcc is 3.2, so I'm safe.

Please check your binutils. >= 2.22 has been reported to work.

Will1
