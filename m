Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbbAVQ3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 11:29:09 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:34929 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbbAVQ3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 11:29:07 -0500
Date: Thu, 22 Jan 2015 08:28:57 -0800
From: Darren Hart <dvhart@infradead.org>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Cc: Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, andy.shevchenko@gmail.com, boon.leong.ong@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] x86: Add Isolated Memory Regions for Quark X1000
Message-ID: <20150122162857.GB66191@vmdeb7>
References: <1421865968-7373-1-git-send-email-pure.logic@nexus-software.ie>
 <1421865968-7373-2-git-send-email-pure.logic@nexus-software.ie>
 <alpine.DEB.2.11.1501221220530.5526@nanos>
 <54C0E13B.2070400@nexus-software.ie>
 <54C11118.801@nexus-software.ie>
 <54C1140E.3070003@nexus-software.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C1140E.3070003@nexus-software.ie>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 03:15:26PM +0000, Bryan O'Donoghue wrote:
> On 22/01/15 15:02, Bryan O'Donoghue wrote:
> >
> >>drivers/platform/x86/intel_qrk_imr.c
> >>
> >>Darren - would that be acceptable to you ?
> >
> >Sorry guys typo - should read arch/x86/platform/imr.c
> >
> >:)
> 
> Ah Thomas actually if I'm understanding you correctly here
> 
> The intention would be to add arch/x86/platform/intel-quark/imr.c and to add

Right, that was my understanding.

-- 
Darren Hart
Intel Open Source Technology Center
