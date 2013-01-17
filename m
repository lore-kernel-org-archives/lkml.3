Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab3AQVwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 16:52:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755608Ab3AQVwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 16:52:22 -0500
Date: Thu, 17 Jan 2013 19:00:26 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 1/3] KVM: x86: clean up reexecute_instruction
Message-ID: <20130117210026.GA21538@amt.cnet>
References: <50F2D64C.4030804@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F2D64C.4030804@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2013 at 11:44:12PM +0800, Xiao Guangrong wrote:
> Little cleanup for reexecute_instruction, also use gpa_to_gfn in
> retry_instruction
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/x86.c |   13 ++++++-------
>  1 files changed, 6 insertions(+), 7 deletions(-)

Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>

