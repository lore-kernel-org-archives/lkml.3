Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762329AbbA2D5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:57:36 -0500
Received: from mga01.intel.com ([192.55.52.88]:49512 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbbA2BIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:08:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,481,1418112000"; 
   d="scan'208";a="669194028"
Date: Wed, 28 Jan 2015 08:43:26 -0800
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:irq/core] genirq: Set initial affinity in
 irq_set_affinity_hint()
Message-ID: <20150128084326.00003e74@unknown>
In-Reply-To: <CAE9FiQWiUF4Rs4+f3q3nww1iNNbVSAZcZX5akYyQa=3Avf1fqg@mail.gmail.com>
References: <20141219012206.4220.27491.stgit@jbrandeb-cp2.jf.intel.com>
	<tip-e2e64a932556cdfae455497dbe94a8db151fc9fa@git.kernel.org>
	<CAE9FiQWiUF4Rs4+f3q3nww1iNNbVSAZcZX5akYyQa=3Avf1fqg@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10cvs7 (GTK+ 2.16.6; i586-pc-mingw32msvc)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2015 22:36:23 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> On Fri, Jan 23, 2015 at 2:42 AM, tip-bot for Jesse Brandeburg
> <tipbot@zytor.com> wrote:
> > Commit-ID:  e2e64a932556cdfae455497dbe94a8db151fc9fa
> > Gitweb:     http://git.kernel.org/tip/e2e64a932556cdfae455497dbe94a8db151fc9fa
> > Author:     Jesse Brandeburg <jesse.brandeburg@intel.com>
> > AuthorDate: Thu, 18 Dec 2014 17:22:06 -0800
> > Committer:  Thomas Gleixner <tglx@linutronix.de>
> > CommitDate: Fri, 23 Jan 2015 11:38:25 +0100
> >
> > genirq: Set initial affinity in irq_set_affinity_hint()

<snip>
 
> there are lots of irq_set_affinity_hint(irq, NULL);
> 
> git grep -A 1 irq_set_affinity_hint | grep NULL | wc -l
> 26
> 
> You may need to add check ...in irq_set_affinity_hint()

I'm looking at this now.  Thanks for the report.
