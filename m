Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbaCMKmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 06:42:09 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:48710 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753693AbaCMKmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 06:42:05 -0400
Date: Thu, 13 Mar 2014 10:41:44 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Salter <msalter@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] generic early_ioremap support
Message-ID: <20140313104144.GD17308@arm.com>
References: <1394677788.5094.89.camel@deneb.redhat.com>
 <20140312195348.5eaccbef.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140312195348.5eaccbef.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 07:53:48PM -0700, Andrew Morton wrote:
> On Wed, 12 Mar 2014 22:29:48 -0400 Mark Salter <msalter@redhat.com> wrote:
> > Could you add this series into the -mm tree for v3.15?
> > 
> > The following changes since commit c3bebc71c4bcdafa24b506adf0c1de3c1f77e2e0:
> > 
> >   Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2014-03-04 08:44:32 -0800)
> > 
> > are available in the git repository at:
> > 
> > 
> >   git://github.com/mosalter/linux.git tags/for-v3.15
> > 
> > for you to fetch changes up to b27e0658d90c63dc2696eca44f7701a903cb13c5:
> > 
> >   doc/kernel-parameters.txt: add early_ioremap_debug (2014-03-09 12:53:50 -0400)
> > 
> > ----------------------------------------------------------------
> > generic early_ioremap support
> 
> Spose so.  I was hoping the x86 and arm people might do it.  Has there
> been sufficient feedback from those parties?

Both x86 and arm64 people acked these patches and we were wondering how
should they get in. Since they touch mm/, Mark thought you could take
them.

-- 
Catalin
