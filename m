Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933618AbaFLN6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 09:58:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932707AbaFLN6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 09:58:11 -0400
Message-ID: <1402581459.15402.54.camel@deneb.redhat.com>
Subject: Re: [PATCH] arm64: fix MAX_ORDER for 64K pagesize
From: Mark Salter <msalter@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 12 Jun 2014 09:57:39 -0400
In-Reply-To: <alpine.DEB.2.02.1406111604060.27885@chino.kir.corp.google.com>
References: <1402522435-13884-1-git-send-email-msalter@redhat.com>
	 <alpine.DEB.2.02.1406111557030.27885@chino.kir.corp.google.com>
	 <alpine.DEB.2.02.1406111604060.27885@chino.kir.corp.google.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-11 at 16:04 -0700, David Rientjes wrote:
> On Wed, 11 Jun 2014, David Rientjes wrote:
> 
> > Any reason to not switch this to
> > 
> > 	ARM64_64K_PAGES && TRANSPARENT_HUGEPAGE && CMA
> > 
> 
> (ARM64_64K_PAGES) && (TRANSPARENT_HUGEPAGE || CMA)

And add HUGETLB to the list also? I'm not sure of all the trade offs
here, so I kept it simple. I don't have a strong opinion one way or
the other.


