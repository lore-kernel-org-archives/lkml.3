Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbaG2XEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 19:04:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123AbaG2XEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 19:04:11 -0400
Message-ID: <53D82857.4020806@redhat.com>
Date: Tue, 29 Jul 2014 19:03:51 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        lszubowi@redhat.com, Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH] x86, efi: print debug values in Kib not MB
References: <1406653761-3884-1-git-send-email-prarit@redhat.com> <20140729222932.GA17481@pd.tnic> <53D82118.6090202@redhat.com> <20140729223603.GC17241@pd.tnic> <alpine.DEB.2.02.1407291541480.20991@chino.kir.corp.google.com> <20140729230102.GD17241@pd.tnic>
In-Reply-To: <20140729230102.GD17241@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/29/2014 07:01 PM, Borislav Petkov wrote:
> On Tue, Jul 29, 2014 at 03:42:55PM -0700, David Rientjes wrote:
>> If Prarit is going to implement this suggested reverse memparse() ...
> 
> The only meaningful argument about the formatting here IMO is what
> people staring at this output are going to understand from it.
> 
> And since those people most often tend to be the poor souls dealing with
> UEFI, we should ask them whether this needs fixing and if so, how.
> 

... I did do a get_maintainers.pl on this before sending it.  Did I miss someone
or some list? :(

P.

> That's it.
> 
