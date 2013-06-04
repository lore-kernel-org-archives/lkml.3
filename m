Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab3FDNXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 09:23:55 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56318 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab3FDNXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 09:23:52 -0400
Date: Tue, 4 Jun 2013 14:23:22 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Khalid Aziz <khalid@gonehiking.org>, Matthew Garrett <mjg@redhat.com>,
        Lv Zheng <lv.zheng@intel.com>, Len Brown <len.brown@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Feng Tang <feng.tang@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>, x86@kernel.org,
        platform-driver-x86@vger.kernel.org, Al Stone <al.stone@linaro.org>
Subject: Re: [PATCH v6 1/2] ACPI: Add early console framework for DBGP/DBG2.
Message-ID: <20130604132322.GA10933@srcf.ucam.org>
References: <cover.1348652044.git.lv.zheng@intel.com>
 <09ee0e9c79c57da2fc9d0af1c2daeaacdc0bb234.1349838218.git.lv.zheng@intel.com>
 <20121010174406.GA13861@srcf.ucam.org>
 <1350069843.7065.65.camel@rhapsody>
 <CACxGe6tC+=98uD=Oc=u-=NHzVKgG9r_3eg+-sG-DQYUnCGw0sA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6tC+=98uD=Oc=u-=NHzVKgG9r_3eg+-sG-DQYUnCGw0sA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 11:53:56AM +0100, Grant Likely wrote:

> Matthew, can you point me at the license Microsoft is using for the
> DBG2 table? I can download the document from Microsoft's site without
> seeing any reference to it being licensed only for BIOS implementers.
> All I see is a "this document is provided 'as-is', blah blah blah"
> blurb at the beginning of the document. It may be that Microsoft has
> changed the license on this document in the last 6 months.

The DBGP spec still seems to have the restrictive license, but I can't 
find it on DBG2.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
