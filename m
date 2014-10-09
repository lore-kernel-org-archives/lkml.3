Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351AbaJIKwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 06:52:36 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:39605 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314AbaJIKw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 06:52:29 -0400
X-IronPort-AV: E=Sophos;i="5.04,684,1406592000"; 
   d="scan'208";a="180882249"
Message-ID: <543668EB.6090900@citrix.com>
Date: Thu, 9 Oct 2014 11:52:27 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>
CC: <Ian.Campbell@citrix.com>, <linux-kernel@vger.kernel.org>,
        <david.vrabel@citrix.com>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH v3 1/2] xen/arm: remove handling of XENFEAT_grant_map_identity
References: <alpine.DEB.2.02.1410081400520.17038@kaball.uk.xensource.com> <1412773496-15364-1-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1412773496-15364-1-git-send-email-stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/14 14:04, Stefano Stabellini wrote:
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

But you should include in commit description the reason why this is
being removed.

David
