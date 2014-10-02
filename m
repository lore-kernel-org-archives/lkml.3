Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbaJBKgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 06:36:11 -0400
Received: from smtp.citrix.com ([66.165.176.89]:50648 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbaJBKgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 06:36:10 -0400
X-IronPort-AV: E=Sophos;i="5.04,638,1406592000"; 
   d="scan'208";a="177418829"
Message-ID: <542D2A97.3040901@citrix.com>
Date: Thu, 2 Oct 2014 11:36:07 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>
CC: <Ian.Campbell@citrix.com>, <linux-kernel@vger.kernel.org>,
        <david.vrabel@citrix.com>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH 1/2] xen/arm: remove handling of XENFEAT_grant_map_identity
References: <alpine.DEB.2.02.1410021102480.17038@kaball.uk.xensource.com> <1412244417-12251-1-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1412244417-12251-1-git-send-email-stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/14 11:06, Stefano Stabellini wrote:
> Keep the definition of the flag.

If this is going away in Xen, you can get rid of the flag as well.

I think you should explain why it's being removed as well.

Should this be tagged for stable as well?

David
