Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab3LMOZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:25:32 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:44110 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab3LMOZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:25:31 -0500
Date: Fri, 13 Dec 2013 09:24:14 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, george.dunlap@eu.citrix.com,
        ian.jackson@eu.citrix.com, mukesh.rathor@oracle.com, tim@xen.org,
        jbeulich@suse.com, boris.ostrovsky@oracle.com,
        Alexander Duyck <alexander.h.duyck@intel.com>
Subject: Re: [PATCH V10 08/14] x86/xen: Use __pa_symbol instead of __pa on C
 visible symbols
Message-ID: <20131213142414.GC2923@phenom.dumpdata.com>
References: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com>
 <1386900621-27528-9-git-send-email-konrad.wilk@oracle.com>
 <52AAE9BD.9060305@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52AAE9BD.9060305@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 11:04:29AM +0000, David Vrabel wrote:
> On 13/12/13 02:10, Konrad Rzeszutek Wilk wrote:
> > From: Alexander Duyck <alexander.h.duyck@intel.com>
> > 
> > This change updates a few of the functions to use __pa_symbol when
> > translating C visible symbols instead of __pa.  By using __pa_symbol we are
> > able to drop a few extra lines of code as don't have to test to see if the
> > virtual pointer is a part of the kernel text or just standard virtual memory.
> 
> Why is this part of the PVH series?

B/c this patch was sent when the #linux-next had the PVH patches and it
was based on that.

> 
> David
