Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab3KDUoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:44:16 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:30207 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab3KDUoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:44:14 -0500
Date: Mon, 4 Nov 2013 15:43:04 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Bjorn Helgaas <bhelgaas@google.com>, ian.campbell@citrix.com
Cc: George Dunlap <george.dunlap@eu.citrix.com>,
        xen-devel <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] xen/pci: Deal with toolstack missing an
 'XenbusStateClosing'.
Message-ID: <20131104204304.GA18492@phenom.dumpdata.com>
References: <20130610202456.GA17822@phenom.dumpdata.com>
 <1370898399-20968-1-git-send-email-konrad.wilk@oracle.com>
 <1370898399-20968-2-git-send-email-konrad.wilk@oracle.com>
 <51B743EA.5020800@eu.citrix.com>
 <51B74B77.1000806@oracle.com>
 <51B74DA9.7060509@eu.citrix.com>
 <20130612134504.GG2918@phenom.dumpdata.com>
 <CAErSpo7zw3MSNzdjRcZuy44uOGT_GZ8T4vaqgkd1fvWG4fadTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo7zw3MSNzdjRcZuy44uOGT_GZ8T4vaqgkd1fvWG4fadTA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Sure; this is your baby :)  Why don't you handle it via your tree,
> since it's more related to xen than any PCI core stuff.
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Definitly fixed in v3.12. Just tested it and it works.

George, Ian, how do I "close" a bug in http://bugs.xenproject.org/xen/bug/12 ?
