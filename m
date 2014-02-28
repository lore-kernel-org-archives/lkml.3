Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838AbaB1GX3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 01:23:29 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:40758 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaB1GX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 01:23:27 -0500
Date: Fri, 28 Feb 2014 06:23:25 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: "alan@linux.intel.com" <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Len.Brown@intel.com, Adam Williamson <awilliam@redhat.com>
Subject: Re: [patch] x86: Introduce BOOT_EFI and BOOT_CF9 into the reboot
 sequence loop
Message-ID: <20140228062325.GA3246@srcf.ucam.org>
References: <53100C8D.1060001@linux.intel.com>
 <20140228045637.GA28257@srcf.ucam.org>
 <53101D1D.9010202@linux.intel.com>
 <20140228055629.GA847@srcf.ucam.org>
 <531027BE.2010807@linux.intel.com>
 <20140228061254.GA2226@srcf.ucam.org>
 <53102AB9.40600@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53102AB9.40600@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 02:20:41PM +0800, Li, Aubrey wrote:

> Well, I already figured that out. Reset Register Supported flag is ZERO
> in FACP table. I attached this table for your interesting.

Ok, in that case we need to check how Windows deals with a FACP that has 
this flag set to 0 but valid looking registers defined. I'll see if I 
can do that tomorrow.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
