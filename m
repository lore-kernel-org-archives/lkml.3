Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761242AbbA1GOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 01:14:25 -0500
Received: from ozlabs.org ([103.22.144.67]:39952 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809AbbA1GOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 01:14:24 -0500
Message-ID: <1422425662.11009.3.camel@ellerman.id.au>
Subject: Re: [PATCHv2 0/8] Fix perf probe issues on powerpc
From: Michael Ellerman <mpe@ellerman.id.au>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        acme@kernel.org, ananth@in.ibm.com
Date: Wed, 28 Jan 2015 17:14:22 +1100
In-Reply-To: <20150128054245.GA2078@naverao1-tp.in.ibm.com>
References: <cover.1418654435.git.naveen.n.rao@linux.vnet.ibm.com>
	 <20150128054245.GA2078@naverao1-tp.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-28 at 11:12 +0530, Naveen N. Rao wrote:
> On 2014/12/15 08:20PM, Naveen N Rao wrote:
> > This patchset fixes various issues with perf probe on powerpc across ABIv1 and
> > ABIv2:
> > - in the presence of DWARF debug-info,
> > - in the absence of DWARF, but with the symbol table, and
> > - in the absence of debug-info, but with kallsyms.
> > 
> > Applies cleanly on -tip. Tested on ppc64 BE and LE.
> > 
> > Changes from previous version:
> > Addressed various review comments from Mike Ellerman largely to generalize
> > changes. Some of the simpler patches have been retained in their previous form
> > to limit code churn, while others have been generalized by introducing arch
> > helpers. Individual patches have more details.
> 
> Michael,
> Can you please take a quick look at this?

I merged patch 1.

https://git.kernel.org/cgit/linux/kernel/git/mpe/linux.git/commit/?h=next&id=bf794bf52a80c6278a028f0af2ca32d7c3508c9b

The rest are not for me, they're perf tools, so you need to convince acme
they're good.

cheers


