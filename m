Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934099AbbA1FnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 00:43:16 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:47662 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbbA1FnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 00:43:15 -0500
Date: Wed, 28 Jan 2015 11:12:45 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        acme@kernel.org, mpe@ellerman.id.au
Cc: ananth@in.ibm.com
Subject: Re: [PATCHv2 0/8] Fix perf probe issues on powerpc
Message-ID: <20150128054245.GA2078@naverao1-tp.in.ibm.com>
References: <cover.1418654435.git.naveen.n.rao@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1418654435.git.naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012805-0033-0000-0000-000004161C81
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/15 08:20PM, Naveen N Rao wrote:
> This patchset fixes various issues with perf probe on powerpc across ABIv1 and
> ABIv2:
> - in the presence of DWARF debug-info,
> - in the absence of DWARF, but with the symbol table, and
> - in the absence of debug-info, but with kallsyms.
> 
> Applies cleanly on -tip. Tested on ppc64 BE and LE.
> 
> Changes from previous version:
> Addressed various review comments from Mike Ellerman largely to generalize
> changes. Some of the simpler patches have been retained in their previous form
> to limit code churn, while others have been generalized by introducing arch
> helpers. Individual patches have more details.

Michael,
Can you please take a quick look at this?

- Naveen
 

