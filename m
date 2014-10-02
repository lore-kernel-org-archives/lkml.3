Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaJBLeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 07:34:09 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:41440 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaJBLeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 07:34:07 -0400
X-IronPort-AV: E=Sophos;i="5.04,638,1406592000"; 
   d="scan'208";a="178489643"
Date: Thu, 2 Oct 2014 12:31:55 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: David Vrabel <david.vrabel@citrix.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>, <Ian.Campbell@citrix.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH 1/2] xen/arm: remove handling of
 XENFEAT_grant_map_identity
In-Reply-To: <542D2A97.3040901@citrix.com>
Message-ID: <alpine.DEB.2.02.1410021230410.17038@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1410021102480.17038@kaball.uk.xensource.com> <1412244417-12251-1-git-send-email-stefano.stabellini@eu.citrix.com> <542D2A97.3040901@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2014, David Vrabel wrote:
> On 02/10/14 11:06, Stefano Stabellini wrote:
> > Keep the definition of the flag.
> 
> If this is going away in Xen, you can get rid of the flag as well.
> 
> I think you should explain why it's being removed as well.

I want to keep the definition of the flag in Xen to avoid the number
being reused. I guess there is no need to keep it in Linux though.


> Should this be tagged for stable as well?

Yep
