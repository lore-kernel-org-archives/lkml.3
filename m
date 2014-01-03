Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbaACPBo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 10:01:44 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55543 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751931AbaACPBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 10:01:43 -0500
Date: Fri, 3 Jan 2014 14:59:17 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Mark Salter <msalter@redhat.com>, catalin.marinas@arm.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        Chen Baozi <baozich@gmail.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm64/xen: redefine xen_remap on arm64
Message-ID: <20140103145917.GP7383@n2100.arm.linux.org.uk>
References: <1388386511-32276-1-git-send-email-baozich@gmail.com> <1388431259.2564.15.camel@deneb.redhat.com> <alpine.DEB.2.02.1401031310100.8667@kaball.uk.xensource.com> <20140103143104.GN7383@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1401031444550.8667@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401031444550.8667@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 03, 2014 at 02:49:54PM +0000, Stefano Stabellini wrote:
> OK. That would be Rob's patch below.

Looks fine to me.

> Are you going to take care of sending it to Linus?

If you want to stick it in the patch system, I'll throw it in my tree.
I need to push out the next set of fixes soon anyway.

Thanks.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
