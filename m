Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaHUPYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 11:24:45 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:45176 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751222AbaHUPYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 11:24:43 -0400
Date: Thu, 21 Aug 2014 17:24:35 +0200
From: Florian Westphal <fw@strlen.de>
To: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Cc: Florian Westphal <fw@strlen.de>, Zhouyi Zhou <zhouzhouyi@gmail.com>,
        pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jbaron@akamai.com
Subject: Re: [PATCH 1/1] netfilter/jump_label: use HAVE_JUMP_LABEL?
Message-ID: <20140821152435.GB16498@breakpoint.cc>
References: <1408589568-27046-1-git-send-email-yizhouzhou@ict.ac.cn>
 <20140821121132.GA16498@breakpoint.cc>
 <1498523.4b875.147f8a0e3c8.Coremail.yizhouzhou@ict.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1498523.4b875.147f8a0e3c8.Coremail.yizhouzhou@ict.ac.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhouyi Zhou <yizhouzhou@ict.ac.cn> wrote:
> > > 
> > > CONFIG_JUMP_LABEL doesn't ensure HAVE_JUMP_LABEL, if it
> > > is not the case use maintainers's own mutex to guard
> > > the modification of global values.
> 
> CONFIG_JUMP_LABEL says the user wants to use jump labels.
> But we also need the toolchain to support it.
> 
> That is reflected in CC_HAVE_ASM_GOTO=y, and if both are
> set then HAVE_JUMP_LABEL is set to true.

Please resubmit and update the changelog to reflect this,
e.g. add something like

Use HAVE_JUMP_LABEL as elsewhere in the kernel to ensure
that the toolchain has the required support in addition to
CONFIG_JUMP_LABEL being set.
