Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab3A2EhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 23:37:06 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:43694 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab3A2EhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 23:37:02 -0500
Date: Tue, 29 Jan 2013 04:36:53 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jiang Liu <jiang.liu@huawei.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jiang Liu <liuj97@gmail.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [RFC PATCH v5 4/8] ACPI, PCI: avoid building pci_slot as module
Message-ID: <20130129043653.GB14395@srcf.ucam.org>
References: <1358525267-14268-1-git-send-email-jiang.liu@huawei.com>
 <1358525267-14268-5-git-send-email-jiang.liu@huawei.com>
 <3500982.MUDp6kKU3R@vostro.rjw.lan>
 <CAErSpo4fbNzFaBxH+eKD+BKVgghyCJEYLDMzc6_gdxABAPe3QQ@mail.gmail.com>
 <CAE9FiQVM4+Wirpb3_D0Zxi4r1p9SAMi4ZrNYr=-eas-C6pKJYA@mail.gmail.com>
 <CAErSpo7WbbzZ8cKfLvuE331ofWir2vswUnYaxVLBBYGFowedXQ@mail.gmail.com>
 <CAE9FiQXkrYubkgbbOXmrEXvGZBZXMZ6sh8kGTpF1_=tD3OMPJw@mail.gmail.com>
 <CAErSpo7vHXdh=ogvfZnxx9gqgiifWGa=XzS+ZKjXFFOPue4TTw@mail.gmail.com>
 <CAE9FiQU84OSQrQJEGAQTDzVv8kGCi+fmgM8+ycoMXMUfHsNe-g@mail.gmail.com>
 <51072EDA.2000704@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51072EDA.2000704@huawei.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 10:07:22AM +0800, Jiang Liu wrote:

> 	Could we use quirk to auto-disable PCIe native hotplug for
> problematic platforms?

Do these problematic platforms successfully boot Windows 7?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
