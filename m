Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab3HOFPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 01:15:36 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:48058 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab3HOFPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 01:15:34 -0400
Date: Thu, 15 Aug 2013 06:15:09 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: RFC: default CONFIG_EFI_STUB=y
Message-ID: <20130815051509.GB1933@srcf.ucam.org>
References: <52050985.9070107@zytor.com>
 <1376062345.2087.16.camel@dabdike.int.hansenpartnership.com>
 <52050D03.4030805@zytor.com>
 <520A7B48.3020304@zytor.com>
 <1376419410.3467.67.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376419410.3467.67.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 11:43:30AM -0700, James Bottomley wrote:

> Can we actually boot a 32 bit kernel on an EFI64 system?  The last time
> I tried on my Secure Boot SDV it wouldn't work; the problem is getting
> someting in the transfer of control path to boot the processor back to
> 32 bit mode.

In theory, as long as you jump to the 32-bit entry point having already 
set the cpu to that mode. The linux command in grub2 ought to do that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
