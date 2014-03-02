Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbaCBW1P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 17:27:15 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:42795 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbaCBW1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 17:27:14 -0500
Date: Sun, 2 Mar 2014 22:26:54 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, Len.Brown@intel.com,
        Adam Williamson <awilliam@redhat.com>
Subject: Re: [patch] x86: Introduce BOOT_EFI and BOOT_CF9 into the reboot
 sequence loop
Message-ID: <20140302222654.GA17838@srcf.ucam.org>
References: <ec95d575-070f-4c62-8b27-3ce281cb192e@email.android.com>
 <53127AA7.8040700@linux.intel.com>
 <53127C4B.1060505@zytor.com>
 <53128DA0.9060105@linux.intel.com>
 <53129256.6060704@zytor.com>
 <20140302022334.GA1131@srcf.ucam.org>
 <c4f4929e-6bab-45b9-ac6b-cbdea5fd57e8@email.android.com>
 <53130A46.1010801@linux.intel.com>
 <cfbdc582-9fc0-4335-9974-d508c2da1c71@email.android.com>
 <5313AD1B.6050403@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5313AD1B.6050403@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 06:13:47AM +0800, Li, Aubrey wrote:

> If you have a system can't be rebooted by all of the known methods, we
> have to figure out how to make reboot work and add the new methods.

The only methods used by Windows are the keyboard controller, the ACPI 
registers and (according to your results) the EFI reboot mechanism. If 
none of those work under Linux but Windows is able to reboot 
successfully then we don't need to add new methods, we need to find out 
why the existing methods don't work.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
