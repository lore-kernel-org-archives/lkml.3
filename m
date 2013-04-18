Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967265Ab3DRPR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 11:17:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966917Ab3DRPR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 11:17:27 -0400
Date: Thu, 18 Apr 2013 11:17:08 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Matt Fleming <matt@console-pimps.org>,
        "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Darren Hart <darren.hart@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode
Message-ID: <20130418151708.GH18383@hansolo.jdub.homelinux.org>
References: <1366127886-31460-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie>
 <516EAC4A.6040202@console-pimps.org>
 <516F1B90.9040508@nexus-software.ie>
 <516FD24A.3070502@console-pimps.org>
 <20130418134059.GF18383@hansolo.jdub.homelinux.org>
 <1366297271.13667.14.camel@x230.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366297271.13667.14.camel@x230.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 03:01:12PM +0000, Matthew Garrett wrote:
> On Thu, 2013-04-18 at 09:40 -0400, Josh Boyer wrote:
> 
> > BGRT is a new addition in ACPI 5.0, right?  Hopefully with it being
> > relatively recent, and new 32-bit firmware being somewhat rare, it won't
> > be a problem.
> 
> New 32-bit UEFI firmware is fairly common. Thanks, Intel.

See.  I said I was the wrong person to weigh in.  And I'm now also sad.

josh
