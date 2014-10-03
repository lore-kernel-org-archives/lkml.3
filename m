Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442AbaJCIHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 04:07:25 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:50689 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbaJCIHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 04:07:17 -0400
Message-ID: <542E592E.2040308@collabora.co.uk>
Date: Fri, 03 Oct 2014 10:07:10 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Olof Johansson <olof@lixom.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the arm-soc tree
References: <20141002113742.2b521495@canb.auug.org.au> <14357384.nIoLZkacVq@wuerfel> <542E4721.8040300@collabora.co.uk> <20141003075623.GU5182@n2100.arm.linux.org.uk>
In-Reply-To: <20141003075623.GU5182@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

On 10/03/2014 09:56 AM, Russell King - ARM Linux wrote:
> On Fri, Oct 03, 2014 at 08:50:09AM +0200, Javier Martinez Canillas wrote:
>> Hello Arnd, Stephen,
>> 
>> I'm so sorry about the breakage, when I posted this patch I mentioned that
>> it was meant for the 3.18-rc cycle once 3.18-rc1 was released [0]. Because
>> it fixes a regression caused by a patch queued in the clock tree for 3.18.
>> I should had been more explicit about the dependencies to avoid confusions.
> 
> If a patch is known to cause a regression, it shouldn't be going in during
> the merge window _or_ the fix patch should also go in during the merge
> window via the same route to resolve the regression before it's noticable.
> 
> Given the number of changes which go in during the merge window, waiting
> for -rc to fix a known bug *before* the merge window is not on - it breaks
> the ability to bisect during the period where bisect really is needed.
> 

I'm not the author of the patch that caused the regression, I just was bitten
by it and proposed a fix. So please don't kill the messenger :-)

Sorry, I didn't know about this rule, otherwise I would had asked Mike to pick
the fix instead. Or at least ask Kukjin to provide an immutable branch so Mike
could merge it on his clock tree.

Best regards,
Javier
