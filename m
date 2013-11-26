Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648Ab3KZU1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 15:27:52 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:50080 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab3KZU1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 15:27:51 -0500
Date: Tue, 26 Nov 2013 20:27:34 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lv Zheng <lv.zheng@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        linux-acpi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ACPI: Cleanup <acpi/acpi.h>, <acpi/acpi_bus.h> and
 <acpi/acpi_drivers.h> inclusions.
Message-ID: <20131126202734.GA18393@srcf.ucam.org>
References: <cover.1385094640.git.lv.zheng@intel.com>
 <3c5e408cd7791ef746f462c79ce28f67734817d9.1385434808.git.lv.zheng@intel.com>
 <2011704.hD86fZ2Qk5@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2011704.hD86fZ2Qk5@vostro.rjw.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 09:29:33PM +0100, Rafael J. Wysocki wrote:> 
> Peter, Matthew, Tony, Konrad, Greg, Bjorn, do you have any objections 
> against this?

I'm fine with it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
