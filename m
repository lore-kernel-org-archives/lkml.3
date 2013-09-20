Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab3ITOjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 10:39:43 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:51168 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab3ITOjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 10:39:41 -0400
Date: Fri, 20 Sep 2013 16:39:32 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Anoop Thomas Mathew <atm@profoundis.com>
Cc: vgupta@synopsys.com, tony.luck@intel.com, davem@davemloft.net,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-ia64@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
        Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH] Fixed typo on word accounting in kprobes.c in mutliple
 architectures
Message-ID: <20130920143932.GA4017@osiris>
References: <20130918210351.GA13811@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130918210351.GA13811@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092014-2966-0000-0000-000008D2A384
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 02:33:58AM +0530, Anoop Thomas Mathew wrote:
> Signed-off-by: Anoop Thomas Mathew <atm@profoundis.com>
> ---
>  arch/arc/kernel/kprobes.c     |    2 +-
>  arch/ia64/kernel/kprobes.c    |    2 +-
>  arch/powerpc/kernel/kprobes.c |    2 +-
>  arch/s390/kernel/kprobes.c    |    2 +-
>  arch/sparc/kernel/kprobes.c   |    2 +-
>  5 files changed, 5 insertions(+), 5 deletions(-)

Please send trivial typo fixes to Jiri Kosina <trivial@kernel.org>.
See "TRIVIAL PATCHES" in MAINTAINERS. Thanks!

