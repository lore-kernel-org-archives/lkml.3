Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815Ab3JROIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 10:08:30 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52201 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755105Ab3JROI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 10:08:28 -0400
Date: Fri, 18 Oct 2013 15:07:12 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH v8 16/19] arm,arm64: do not always merge biovec if we
 are running on Xen
Message-ID: <20131018140711.GO23462@arm.com>
References: <alpine.DEB.2.02.1310171833520.26077@kaball.uk.xensource.com>
 <1382031814-8782-16-git-send-email-stefano.stabellini@eu.citrix.com>
 <alpine.DEB.2.02.1310181322301.26077@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1310181322301.26077@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 01:23:59PM +0100, Stefano Stabellini wrote:
> are you OK with this patch?
> 
> It shouldn't have any impact when running on native, only on Xen.

I don't have an opinion on what it does but since it only affects Xen,
it's fine by me.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
