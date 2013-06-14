Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab3FNQ2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:28:45 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:47400 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab3FNQ2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:28:42 -0400
Date: Fri, 14 Jun 2013 12:28:31 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: George Dunlap <george.dunlap@eu.citrix.com>,
        xen-devel <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] xen/pci: Deal with toolstack missing an
 'XenbusStateClosing'.
Message-ID: <20130614162831.GA16636@phenom.dumpdata.com>
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
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> So at least part of the problem *is* a bug in Linux.
> >
> > Good! Bjorn, would you be OK Ack-ing the patch I sent (attached here
> > for reference) or putting it in your queue for Linus?
> >
> > My plan would be to send it to Linus in the 3.11 merge window.
> 
> Sure; this is your baby :)  Why don't you handle it via your tree,
> since it's more related to xen than any PCI core stuff.

OK. Thanks!
