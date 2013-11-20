Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab3KTAfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 19:35:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421Ab3KTAfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 19:35:40 -0500
Date: Tue, 19 Nov 2013 22:35:21 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 04/12] KVM: MMU: log dirty page after marking spte
 writable
Message-ID: <20131120003521.GA15809@amt.cnet>
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1375189330-24066-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130807014828.GA4781@amt.cnet>
 <5201C7D9.20004@linux.vnet.ibm.com>
 <20131120002920.GA14230@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131120002920.GA14230@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 10:29:20PM -0200, Marcelo Tosatti wrote:
> A call to GET_DIRTY_LOG guarantees to return correct information about 
> dirty pages before invocation of the previous GET_DIRTY_LOG call.

> Can you explain why it is OK to relax this rule?

That is, this might be OK, but better understand why it is.

