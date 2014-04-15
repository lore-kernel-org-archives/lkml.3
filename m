Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbaDOPUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 11:20:16 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:36694 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaDOPUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 11:20:11 -0400
Date: Tue, 15 Apr 2014 11:20:01 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen/pci: Remove unused dev_err() string
Message-ID: <20140415152001.GA6187@phenom.dumpdata.com>
References: <20140414222523.15032.99127.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140415130319.GC29540@phenom.dumpdata.com>
 <534D342C.2040805@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534D342C.2040805@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 02:29:16PM +0100, David Vrabel wrote:
> On 15/04/14 14:03, Konrad Rzeszutek Wilk wrote:
> > On Mon, Apr 14, 2014 at 04:25:23PM -0600, Bjorn Helgaas wrote:
> >> We previously verified that "action" is either BUS_NOTIFY_ADD_DEVICE or
> >> BUS_NOTIFY_DEL_DEVICE, so there's no need for the default "?" case.
> >>
> >> Found by Coverity (CID 146520).
> > 
> > Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > 
> > David, are you OK pushing this in 'devel/for-linus-3.14'?
> 
> If you mean devel/for-linus-3.16, then yes.

Yes I meant that. Thanks!
> 
> David
