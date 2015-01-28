Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761605AbbA1Gnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 01:43:32 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:39500 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbbA1Gnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 01:43:31 -0500
Date: Wed, 28 Jan 2015 12:13:02 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        acme@kernel.org, ananth@in.ibm.com
Subject: Re: [PATCHv2 0/8] Fix perf probe issues on powerpc
Message-ID: <20150128064302.GB2078@naverao1-tp.in.ibm.com>
References: <cover.1418654435.git.naveen.n.rao@linux.vnet.ibm.com>
 <20150128054245.GA2078@naverao1-tp.in.ibm.com>
 <1422425662.11009.3.camel@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422425662.11009.3.camel@ellerman.id.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012806-0021-0000-0000-000003879564
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/01/28 05:14PM, Michael Ellerman wrote:
> On Wed, 2015-01-28 at 11:12 +0530, Naveen N. Rao wrote:
> > On 2014/12/15 08:20PM, Naveen N Rao wrote:
> > > This patchset fixes various issues with perf probe on powerpc across ABIv1 and
> > > ABIv2:
> > > - in the presence of DWARF debug-info,
> > > - in the absence of DWARF, but with the symbol table, and
> > > - in the absence of debug-info, but with kallsyms.
> > > 
> > > Applies cleanly on -tip. Tested on ppc64 BE and LE.
> > > 
> > > Changes from previous version:
> > > Addressed various review comments from Mike Ellerman largely to generalize
> > > changes. Some of the simpler patches have been retained in their previous form
> > > to limit code churn, while others have been generalized by introducing arch
> > > helpers. Individual patches have more details.
> > 
> > Michael,
> > Can you please take a quick look at this?
> 
> I merged patch 1.
> 
> https://git.kernel.org/cgit/linux/kernel/git/mpe/linux.git/commit/?h=next&id=bf794bf52a80c6278a028f0af2ca32d7c3508c9b
> 
> The rest are not for me, they're perf tools, so you need to convince acme
> they're good.

Oh, thanks! Sorry, I didn't realize you had already merged it.
I assume you are ok with my changes in v2 w.r.t your previous review 
comments.

Arnaldo,
Please have a look at this revision and let me know if you have any 
other concerns. Also, I have missed including Ananth's "Reviewed-by" in 
this patchset.  I'm guessing Ananth is ok with this revision as well.


- Naveen

