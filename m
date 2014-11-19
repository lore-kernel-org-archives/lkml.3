Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbaKSHJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 02:09:18 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:34510 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978AbaKSHJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 02:09:17 -0500
Message-ID: <546C420B.30307@linux.vnet.ibm.com>
Date: Wed, 19 Nov 2014 12:38:59 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Joel Stanley <joel@jms.id.au>
CC: Michael Ellerman <mpe@ellerman.id.au>, Michael Neuling <mikey@neuling.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        rjw@rjwysocki.net
Subject: Re: [PATCH] cpuidle/powernv: Re-enable fastsleep at boot time
References: <20141118065603.22544.88816.stgit@preeti.in.ibm.com> <CACPK8Xc7G6JgqPYUmGTx8O=a6jxMB0yf1weEraMBu8dcAJibuQ@mail.gmail.com>
In-Reply-To: <CACPK8Xc7G6JgqPYUmGTx8O=a6jxMB0yf1weEraMBu8dcAJibuQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111907-0005-0000-0000-00000675F2C8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joel,

On 11/19/2014 08:04 AM, Joel Stanley wrote:
> Hey Preeti,
> 
> On Tue, Nov 18, 2014 at 5:26 PM, Preeti U Murthy
> <preeti@linux.vnet.ibm.com> wrote:
>> Commit dcb18694 "Fix ipi on palmeto" disabled fastsleep at boot time.
> 
> I couldn't find this commit in any tree; upstream, mpe's next, nor powerkvm.

Oh yes you are right. I must have been looking at the wrong git branch.
I verified upstream now. The commit dcb18694 is not present.So we are
good. Thanks for pointing this out :)

Sorry for the noise!
> 
> I remember testing this as a workaround for the palmetto, but I don't
> recall sending it upstream.
> 
> Cheers,
> 
> Joel
> 

Regards
Preeti U Murthy

