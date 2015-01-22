Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbbAVTuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 14:50:40 -0500
Received: from www.linutronix.de ([62.245.132.108]:33048 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbbAVTui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 14:50:38 -0500
Date: Thu, 22 Jan 2015 20:50:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
cc: mingo@redhat.com, hpa@zytor.com, x86@kernel.org, dvhart@infradead.org,
        andy.shevchenko@gmail.com, boon.leong.ong@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] x86: Add Isolated Memory Regions for Quark
 X1000
In-Reply-To: <54C1140E.3070003@nexus-software.ie>
Message-ID: <alpine.DEB.2.11.1501222039300.5526@nanos>
References: <1421865968-7373-1-git-send-email-pure.logic@nexus-software.ie> <1421865968-7373-2-git-send-email-pure.logic@nexus-software.ie> <alpine.DEB.2.11.1501221220530.5526@nanos> <54C0E13B.2070400@nexus-software.ie> <54C11118.801@nexus-software.ie>
 <54C1140E.3070003@nexus-software.ie>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015, Bryan O'Donoghue wrote:
> On 22/01/15 15:02, Bryan O'Donoghue wrote:
> > 
> > > drivers/platform/x86/intel_qrk_imr.c
> > > 
> > > Darren - would that be acceptable to you ?
> > 
> > Sorry guys typo - should read arch/x86/platform/imr.c
> > 
> > :)
> 
> Ah Thomas actually if I'm understanding you correctly here
> 
> The intention would be to add arch/x86/platform/intel-quark/imr.c and to add
> X86_QUARK depending on X86_EXTENDED_PLATFORM
> 
> Which would then include IMR support

That makes sense, especially if there is more Quark in the pipeline.

Thanks,

	tglx
---
German		English
Quark 		curd  [cheese]
Quark		quark [physics]
Quark		nonsense [slang]
