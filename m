Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab3GWKUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 06:20:42 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38277 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756012Ab3GWKUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 06:20:41 -0400
Date: Tue, 23 Jul 2013 11:20:07 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "sergei.shtylyov@cogentembedded.com" 
	<sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v2] xen/arm and xen/arm64: update xen_restart after
 ff701306cd49
Message-ID: <20130723102006.GB3748@MacBook-Pro.local>
References: <1374486464-25243-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374486464-25243-1-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 10:47:44AM +0100, Stefano Stabellini wrote:
> Commit ff701306cd49 (arm64: use common reboot infrastructure) changes
> the prototype of arm_pm_restart.  Update xen_restart accordingly.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

You may even want to quote 7b6d864b48d9 (reboot: arm: change reboot_mode
to use enum reboot_mode) since you are changing a file under arch/arm ;)

-- 
Catalin
