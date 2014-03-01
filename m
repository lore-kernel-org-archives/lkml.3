Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbaCATBX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 14:01:23 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:33559 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbaCATBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 14:01:22 -0500
Date: Sat, 1 Mar 2014 19:01:17 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, Len.Brown@intel.com,
        Adam Williamson <awilliam@redhat.com>
Subject: Re: [patch] x86: Introduce BOOT_EFI and BOOT_CF9 into the reboot
 sequence loop
Message-ID: <20140301190117.GA2147@srcf.ucam.org>
References: <20140228062325.GA3246@srcf.ucam.org>
 <53102F3C.4020806@linux.intel.com>
 <20140228064413.GA4900@srcf.ucam.org>
 <531032A0.8090903@linux.intel.com>
 <5310CBB7.4030407@linux.intel.com>
 <53110977.8080907@linux.intel.com>
 <53121496.8060603@linux.intel.com>
 <20140301172256.GA29417@srcf.ucam.org>
 <53121961.2080209@linux.intel.com>
 <20140301181951.GA984@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140301181951.GA984@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In fact, this is already merged 
(d2f7cbe7b26a74dbbbf8f325b2a6fd01bc34032c), so adding EFI by default 
should be fine. It'd be nice to instrument Windows on OVMF/qemu in order 
to verify the ordering used in different situations.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
