Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468Ab3A2Egh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 23:36:37 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:43673 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab3A2Egf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 23:36:35 -0500
Date: Tue, 29 Jan 2013 04:36:17 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jiang Liu <liuj97@gmail.com>, Jiang Liu <jiang.liu@huawei.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [RFC PATCH v5 4/8] ACPI, PCI: avoid building pci_slot as module
Message-ID: <20130129043617.GA14395@srcf.ucam.org>
References: <1358525267-14268-1-git-send-email-jiang.liu@huawei.com>
 <1358525267-14268-5-git-send-email-jiang.liu@huawei.com>
 <3500982.MUDp6kKU3R@vostro.rjw.lan>
 <CAErSpo4fbNzFaBxH+eKD+BKVgghyCJEYLDMzc6_gdxABAPe3QQ@mail.gmail.com>
 <CAE9FiQVM4+Wirpb3_D0Zxi4r1p9SAMi4ZrNYr=-eas-C6pKJYA@mail.gmail.com>
 <CAErSpo7WbbzZ8cKfLvuE331ofWir2vswUnYaxVLBBYGFowedXQ@mail.gmail.com>
 <CAE9FiQXkrYubkgbbOXmrEXvGZBZXMZ6sh8kGTpF1_=tD3OMPJw@mail.gmail.com>
 <CAErSpo7vHXdh=ogvfZnxx9gqgiifWGa=XzS+ZKjXFFOPue4TTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo7vHXdh=ogvfZnxx9gqgiifWGa=XzS+ZKjXFFOPue4TTw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 03:14:11PM -0700, Bjorn Helgaas wrote:

> CONFIG_ACPI_PCI_SLOT=y in RHEL6, so evidently they have this problem.

I'm not aware of anyone ever filing any bugs against it, either, though 
Myron would have a better idea. What's the worst case outcome of someone 
ending up with an incorrect slot number?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
