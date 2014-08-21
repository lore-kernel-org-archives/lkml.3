Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbaHUMLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:11:45 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44545 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754058AbaHUMLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:11:44 -0400
Date: Thu, 21 Aug 2014 14:11:32 +0200
From: Florian Westphal <fw@strlen.de>
To: Zhouyi Zhou <zhouzhouyi@gmail.com>
Cc: pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jbaron@akamai.com,
        Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: Re: [PATCH 1/1] netfilter/jump_label: use HAVE_JUMP_LABEL?
Message-ID: <20140821121132.GA16498@breakpoint.cc>
References: <1408589568-27046-1-git-send-email-yizhouzhou@ict.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408589568-27046-1-git-send-email-yizhouzhou@ict.ac.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhouyi Zhou <zhouzhouyi@gmail.com> wrote:
> 
> CONFIG_JUMP_LABEL doesn't ensure HAVE_JUMP_LABEL, if it
> is not the case use maintainers's own mutex to guard
> the modification of global values.

I don't understand this patch.

What is the problem you are fixing?

The intent is to only use static_key infrastructure
if user has enabled CONFIG_JUMP_LABEL.
