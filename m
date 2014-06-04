Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbaFDWy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 18:54:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37164 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbaFDWy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 18:54:57 -0400
Message-ID: <538FA332.4000602@zytor.com>
Date: Wed, 04 Jun 2014 15:52:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Borislav Petkov <bp@suse.de>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org,
        ricardo.neri-calderon@linux.intel.com, tglx@linutronix.de,
        matt.fleming@intel.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/efi] x86/efi: Check for unsafe dealing with FPU state
 in irq ctxt
References: <tip-baa916f39b50ad91661534652110df40396acda0@git.kernel.org> <538F9AFA.5050806@zytor.com> <20140604224920.GB4126@pd.tnic>
In-Reply-To: <20140604224920.GB4126@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 03:49 PM, Borislav Petkov wrote:
> On Wed, Jun 04, 2014 at 03:17:30PM -0700, H. Peter Anvin wrote:
>> I seem to have lost track of this... does this actually solve
>> anything, or does it just mean we'll explode hard?
> 
> Not that hard - it'll warn once only.
> 
> AFAIR, the discussion stalled but we were going in the direction of not
> calling into efi from pstore in irq context.
> 
> I'd say we drop this until we have a proper solution.
> 

Works for me.

	-hpa

