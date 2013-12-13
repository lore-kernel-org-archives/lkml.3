Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab3LMO3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:29:00 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:46085 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab3LMO26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:28:58 -0500
Date: Fri, 13 Dec 2013 09:27:46 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, george.dunlap@eu.citrix.com,
        ian.jackson@eu.citrix.com, mukesh.rathor@oracle.com, tim@xen.org,
        jbeulich@suse.com, boris.ostrovsky@oracle.com,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [PATCH V10 09/14] xen: implement updated
 XENMEM_add_to_physmap_range ABI
Message-ID: <20131213142746.GE2923@phenom.dumpdata.com>
References: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com>
 <1386900621-27528-10-git-send-email-konrad.wilk@oracle.com>
 <52AAF100.2020002@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52AAF100.2020002@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 11:35:28AM +0000, David Vrabel wrote:
> On 13/12/13 02:10, Konrad Rzeszutek Wilk wrote:
> > From: Ian Campbell <Ian.Campbell@citrix.com>
> > 
> > Allows for more fine grained error reporting. Only used by PVH and
> > ARM both of which are marked EXPERIMENTAL precisely because the ABI
> > is not yet stable
> 
> This should be folded into patch 7.

In "07/14] xen/x86: remove duplicated include from enlighten.c" ?
> 
> David
