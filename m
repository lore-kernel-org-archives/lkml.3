Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623Ab3CWQWL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 12:22:11 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59017 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab3CWQWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 12:22:09 -0400
Date: Sat, 23 Mar 2013 16:22:02 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] PCI / ACPI: Always resume devices on ACPI wakeup
 notifications
Message-ID: <20130323162202.GA13361@srcf.ucam.org>
References: <2282655.IicBMMa6jN@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2282655.IicBMMa6jN@vostro.rjw.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
