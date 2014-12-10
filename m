Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118AbaLJEIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 23:08:21 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:43728 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060AbaLJEIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 23:08:19 -0500
Date: Wed, 10 Dec 2014 09:41:45 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        mpe@ellerman.id.au
Subject: Re: [RFC PATCH 8/8] perf probe powerpc: Fixup function entry if
 using kallsyms lookup
Message-ID: <20141210041144.GA13398@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
 <e5bfde8d51546041e50699c4ed3bad8c3c1bf84f.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
 <20141209211400.GB8788@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141209211400.GB8788@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121004-0005-0000-0000-000007037372
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 06:14:00PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Dec 09, 2014 at 11:04:06PM +0530, Naveen N. Rao escreveu:
> > On powerpc ABIv2, if no debug-info is found and we use kallsyms,
> > we need to fixup the function entry to point to the local entry point.
> > Use offset of 8 since current toolchains always generate 2
> > instructions (8 bytes).
> 
> Hi Michael and Ananth, may I have your Acked-by or Reviewed-by for these
> patches?
> 
> The ones, like this, that are affects only ppc I'm can assume was tested
> and applying it won't break other arch users, but having a/rev-by from
> ppc developers should speed up this process.

Hi Arnaldo,

Yes, I have reviewed the patches. So, for all patches...

Reviewed-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

