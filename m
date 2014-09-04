Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbaIDM7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 08:59:52 -0400
Received: from smtp.citrix.com ([66.165.176.89]:21355 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbaIDM7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 08:59:51 -0400
X-IronPort-AV: E=Sophos;i="5.04,465,1406592000"; 
   d="scan'208";a="168321809"
Message-ID: <54086244.7020601@citrix.com>
Date: Thu, 4 Sep 2014 13:59:48 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>, <jbeulich@suse.com>
Subject: Re: [PATCH 3/3] xen: eliminate scalability issues from initial mapping
 setup
References: <1409834326-29287-1-git-send-email-jgross@suse.com> <1409834326-29287-4-git-send-email-jgross@suse.com>
In-Reply-To: <1409834326-29287-4-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/14 13:38, Juergen Gross wrote:
> Direct Xen to place the initial P->M table outside of the initial
> mapping, as otherwise the 1G (implementation) / 2G (theoretical)
> restriction on the size of the initial mapping limits the amount
> of memory a domain can be handed initially.

The three level p2m limits memory to 512 GiB on x86-64 but this patch
doesn't seem to address this limit and thus seems a bit useless to me.

David
