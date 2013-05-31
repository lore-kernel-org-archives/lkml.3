Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab3EaXAD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 19:00:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:16545 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129Ab3EaW7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 18:59:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,781,1363158000"; 
   d="scan'208";a="343243917"
Message-ID: <51A92B69.9010108@linux.intel.com>
Date: Fri, 31 May 2013 15:59:53 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Russ Anderson <rja@sgi.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Jiri Kosina <jkosina@suse.cz>, joeyli <jlee@suse.com>,
        Matt Fleming <matt@console-pimps.org>, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
References: <alpine.LNX.2.00.1305310023020.30576@pobox.suse.cz> <20130531101250.GD30394@gmail.com> <alpine.LNX.2.00.1305311259520.30576@pobox.suse.cz> <20130531123015.GC17843@nazgul.tnic> <20130531124356.GA8212@gmail.com> <20130531143425.GA5850@srcf.ucam.org> <1370011357.1913.15.camel@dabdike.int.hansenpartnership.com> <20130531144826.GB5850@srcf.ucam.org> <20130531154348.GA17145@sgi.com> <20130531162815.GA8082@srcf.ucam.org> <20130531225730.GB14752@sgi.com>
In-Reply-To: <20130531225730.GB14752@sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2013 03:57 PM, Russ Anderson wrote:
> 
>>> Which means the previous patch(es) that caused the bricking should
>>> get pulled, too.
>>
>> There are no patches that cause the bricking.
> 
> I thought that was the problem you were trying to avoid.
> 

There are no *patches* that cause the bricking.  We have been trying to
figure out how to *avoid* the bricking.

	-hpa

