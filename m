Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760051Ab3EXHpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 03:45:49 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:55987 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757553Ab3EXHps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 03:45:48 -0400
Date: Fri, 24 May 2013 08:45:44 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Russ Anderson <rja@sgi.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Josh Boyer <jwboyer@redhat.com>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Message-ID: <20130524074544.GM14575@console-pimps.org>
References: <20130522162747.GA20816@sgi.com>
 <20130523115801.GJ14575@console-pimps.org>
 <20130523222321.GB31880@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130523222321.GB31880@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 May, at 05:23:21PM, Russ Anderson wrote:
> Interesting data point.  The failure is on a rhel7/grub2 root.
> The identical kernel on a rhel6/grub root boots.  So maybe
> grub2 brings out the failure?  I suspect Fedora19/grub2 on
> EFI should hit the problem (for someone looking to reproduce
> it).
> 
> In both cases the kernel boot line options are the same.

I'll bet that rhel7 is using the EFI handover protocol which uses the
internal mechanisms of the EFI boot stub.

I don't know whether anyone will be able to reproduce it, it looks like
it's a bug that's specific to your firmware.

-- 
Matt Fleming, Intel Open Source Technology Center
