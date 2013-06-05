Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab3FEJwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:52:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671Ab3FEJwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 05:52:42 -0400
Date: Wed, 5 Jun 2013 12:52:38 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v8 00/11] KVM: MMU: fast zap all shadow pages
Message-ID: <20130605095238.GU4725@redhat.com>
References: <1369960590-14138-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369960590-14138-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 08:36:19AM +0800, Xiao Guangrong wrote:
> Hi Gleb, Paolo, Marcelo,
> 
> I have putted the potential controversial patches to the latter that are
> patch 8 ~ 10, patch 11 depends on patch 9. Other patches are fully reviewed,
> I think its are ready for being merged. If not luck enough, further discussion
> is needed, could you please apply that patches first? :)
> 
> Thank you in advance!
> 
Applied all of them to queue. Thanks!

--
			Gleb.
