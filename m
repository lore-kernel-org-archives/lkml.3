Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab3HALeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 07:34:13 -0400
Received: from smtp.citrix.com ([66.165.176.89]:2403 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835Ab3HALeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 07:34:12 -0400
X-IronPort-AV: E=Sophos;i="4.89,793,1367971200"; 
   d="scan'208";a="40722287"
Message-ID: <51FA47AC.2020507@citrix.com>
Date: Thu, 1 Aug 2013 12:34:04 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <konrad.wilk@oracle.com>,
        <Ian.Campbell@citrix.com>
Subject: Re: [PATCH RFC 6/8] xen: make xen_create_contiguous_region return
 the dma address
References: <alpine.DEB.2.02.1307311833040.4893@kaball.uk.xensource.com> <1375292732-7627-6-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1375292732-7627-6-git-send-email-stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/13 18:45, Stefano Stabellini wrote:
> Modify xen_create_contiguous_region to return the dma address of the
> newly contiguous buffer.

Seems sensible.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David
