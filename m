Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab3EXUev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 16:34:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab3EXUeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 16:34:50 -0400
Date: Fri, 24 May 2013 17:34:32 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 04/11] KVM: MMU: zap pages in batch
Message-ID: <20130524203432.GB4525@amt.cnet>
References: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1369252560-11611-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369252560-11611-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 03:55:53AM +0800, Xiao Guangrong wrote:
> Zap at lease 10 pages before releasing mmu-lock to reduce the overload
> caused by requiring lock
> 
> After the patch, kvm_zap_obsolete_pages can forward progress anyway,
> so update the comments
> 
> [ It improves kernel building 0.6% ~ 1% ]

Can you please describe the overload in more detail? Under what scenario
is kernel building improved?

