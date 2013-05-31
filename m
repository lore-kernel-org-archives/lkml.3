Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab3EaOpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 10:45:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:60575 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab3EaOpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 10:45:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,779,1363158000"; 
   d="scan'208";a="322475603"
Message-ID: <51A8B776.8040701@linux.intel.com>
Date: Fri, 31 May 2013 07:45:10 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Kosina <jkosina@suse.cz>,
        Russ Anderson <rja@sgi.com>, joeyli <jlee@suse.com>,
        Matt Fleming <matt@console-pimps.org>, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
References: <alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz>  <20130529224645.GA16582@sgi.com>  <alpine.LNX.2.00.1305300048520.30576@pobox.suse.cz>  <1369880172.17397.11.camel@linux-s257.site>  <20130530221737.GA11105@sgi.com>  <alpine.LNX.2.00.1305310023020.30576@pobox.suse.cz>  <20130531101250.GD30394@gmail.com>  <alpine.LNX.2.00.1305311259520.30576@pobox.suse.cz>  <20130531123015.GC17843@nazgul.tnic> <20130531124356.GA8212@gmail.com>  <20130531143425.GA5850@srcf.ucam.org> <1370011357.1913.15.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1370011357.1913.15.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2013 07:42 AM, James Bottomley wrote:
> 
> The only ones that are broken are the Samsung ones.  Samsung claims to
> have fixed their UEFI firmware, so we could refer any problems to them.
> 
> The signature of the Samsung failure, which this is guarding against is
> that the laptop gets bricked, so it really is a nasty choice of poisons
> we have to pick...
> 

Are we sure it is only Samsung?  I was under the impression there were
other systems with similar failures?

	-hpa


