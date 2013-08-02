Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862Ab3HBMBO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 08:01:14 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29132 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab3HBMBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 08:01:13 -0400
Date: Fri, 2 Aug 2013 08:01:02 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xen-devel <xen-devel@lists.xen.org>, Feng Jin <joe.jin@oracle.com>,
        Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>
Subject: Re: [PATCH 2/3] Refactor msi/msix restore code Part2
Message-ID: <20130802120101.GE24540@konrad-lan.dumpdata.com>
References: <51EF451A.8050003@oracle.com>
 <CAErSpo5phkLpdR35eaMnYthVXiAAAr-JLD44QkntOZi2-NppOg@mail.gmail.com>
 <20130801151616.GE21528@konrad-lan.dumpdata.com>
 <51FB78D1.6060802@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FB78D1.6060802@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>Konrad, are you OK with this patch now?
> >Yes, I wanted to make sure that the existing behavior under baremetal
> >was not altered.
> >
> >And Duan had confirmed it was not  - thought to be on a safe side it
> >would be good to confirm this via testing just in case.
> I had ever let our customer test on baremetal and it passed.

Are they OK with being credited for this in the patch? Meaning are they
OK with Reported-by-and-Tested-by: flag?

Either way, I think the only remaining issue is to expand the git commit
a bit to include the discussion about the flow of the pci_read/pci_write
and point out that the logic remains the same.


> 
> zduan
