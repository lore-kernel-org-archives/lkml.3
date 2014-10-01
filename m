Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaJAJA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 05:00:27 -0400
Received: from outbound-smtp01.blacknight.com ([81.17.249.7]:48738 "EHLO
	outbound-smtp01.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751995AbaJAJAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 05:00:22 -0400
Message-ID: <542BC2A2.7090001@nexus-software.ie>
Date: Wed, 01 Oct 2014 10:00:18 +0100
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: mingo@redhat.com, hpa@zytor.com, davej@redhat.com, hmh@hmh.eng.br,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] x86: Quark: Add legacy_cache_size and TLB comments
References: <1412120517-14738-1-git-send-email-pure.logic@nexus-software.ie> <alpine.DEB.2.11.1410010153590.4455@nanos> <542B4B16.6060401@nexus-software.ie> <alpine.DEB.2.11.1410011040040.4455@nanos>
In-Reply-To: <alpine.DEB.2.11.1410011040040.4455@nanos>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/14 09:57, Thomas Gleixner wrote:
> On Wed, 1 Oct 2014, Bryan O'Donoghue wrote:
>> On 01/10/14 01:11, Thomas Gleixner wrote:
>> On the substance.
>> I'm certainly not trying to antagonise you here - I assumed you were
>> *suggesting* to apply those comments directly ?
>> Which is why I updated the sent patches with your comments - since they
>> seemed more descriptive anyway - and sent back to the list.
>
> That part is fine. What really annoyed me is the patch:
>
> Subject: [PATCH] x86: Call identify_cpu() unconditionally once remove other
>       callsites
>
> which is a complete fail in all aspects. You should be able to figure
> that out yourself easily:
>
> Read the reviews of "[PATCH 1/3] x86: Bugfix bit-rot in the calling of
> legacy_cache_size" again carefully. Then look at your patch, the
> subject line and the changelog. It should be pretty obvious.

OK - I'll read again.

Thanks for the reviews

