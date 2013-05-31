Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab3EaOlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 10:41:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:39527 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755337Ab3EaOlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 10:41:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,779,1363158000"; 
   d="scan'208";a="249120648"
Message-ID: <51A8B686.9020603@linux.intel.com>
Date: Fri, 31 May 2013 07:41:10 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Russ Anderson <rja@sgi.com>
CC: Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Josh Boyer <jwboyer@redhat.com>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
References: <20130522162747.GA20816@sgi.com> <20130523115801.GJ14575@console-pimps.org> <20130523222321.GB31880@sgi.com> <20130524074544.GM14575@console-pimps.org> <20130529201616.GB28027@sgi.com>
In-Reply-To: <20130529201616.GB28027@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2013 01:16 PM, Russ Anderson wrote:
> 
> To be more specific (now that I've dug through the code), grub2 (used
> by rhel7) uses EFI boot stubs.  grub and elilo apparently do not use
> EFI boot stubs, so they don't hit the problem (at least on my test
> systems).
> 

Grub2 *can* use the EFI boot stub... as far as I know it doesn't by
default, but the way it is used in RHEL does.

Either way, we need to fix this and fix it soon.

	-hpa


