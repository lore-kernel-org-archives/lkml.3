Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab3FYSUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:20:33 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56040 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab3FYSUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:20:31 -0400
Date: Tue, 25 Jun 2013 19:20:21 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, hpa@linux.intel.com, tglx@linutronix.de,
        matt.fleming@intel.com
Subject: Re: [PATCH 3/4] arm: Add [U]EFI runtime services support
Message-ID: <20130625182021.GA29955@srcf.ucam.org>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org>
 <1372183863-11333-4-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372183863-11333-4-git-send-email-leif.lindholm@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 07:11:02PM +0100, Leif Lindholm wrote:
> This patch implements basic support for UEFI runtime services in the
> ARM architecture - a requirement for using efibootmgr to read and update
> the system boot configuration.
> 
> It also locates any presented SMBIOS configuration table and stores it
> for potential later use by DMI.

This appears to duplicate code that's already duplicated between x86 and 
ia64. We made a mistake there originally - let's not do it again. Having 
this code in three places is inevitably going to lead to skew and missed 
bugfixes.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
