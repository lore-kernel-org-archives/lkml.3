Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbaHKL6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:58:53 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:31532 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaHKL6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:58:51 -0400
X-IronPort-AV: E=Sophos;i="5.01,841,1400025600"; 
   d="scan'208";a="161209858"
Message-ID: <53E8AFF7.70207@citrix.com>
Date: Mon, 11 Aug 2014 12:58:47 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dave Scott <Dave.Scott@eu.citrix.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen_hvc: no reason to write the type key on xenstore
References: <alpine.DEB.2.02.1408111250150.2293@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1408111250150.2293@kaball.uk.xensource.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/14 12:54, Stefano Stabellini wrote:
> The backend type is chosen by the toolstack. Regardless, the frontend
> should not care, especially given that it cannot have an effect as the
> backend is started before this code is run.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

This needs go via the TTY subsystem (you didn't Cc the maintainers).

David
