Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab3BELrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 06:47:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab3BELrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 06:47:19 -0500
Date: Tue, 5 Feb 2013 13:47:16 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 0/3] KVM: MMU: simple cleanups
Message-ID: <20130205114716.GF23213@redhat.com>
References: <5110B41D.3090605@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5110B41D.3090605@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 03:26:21PM +0800, Xiao Guangrong wrote:
> There are the simple cleanups for MMU, no function / logic changed.
> 
> Marcelo, Gleb, please apply them after applying
> "[PATCH v3] KVM: MMU: lazily drop large spte"
> 
> Changelog:
> no change, just split them from the previous patchset for good review.
> 
> Thanks!
Reviewed-by: Gleb Natapov <gleb@redhat.com>

--
			Gleb.
