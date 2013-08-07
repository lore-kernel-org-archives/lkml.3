Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532Ab3HGOK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 10:10:58 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:60472 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757456Ab3HGOK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 10:10:57 -0400
MIME-Version: 1.0
In-Reply-To: <20130803160628.GL2580@book.gsilab.sittig.org>
References: <1375255254-10955-1-git-send-email-a13xp0p0v88@gmail.com>
	<20130803160628.GL2580@book.gsilab.sittig.org>
Date: Wed, 7 Aug 2013 18:10:56 +0400
Message-ID: <CAF0T0X6cwQPR4-imsev3Xd16usfjEABwm7hYxdJgvrMWZ=tBHA@mail.gmail.com>
Subject: Re: [PATCH RFC v3 1/5] dma: mpc512x: reorder mpc8308 specific instructions
From: Alexander Popov <a13xp0p0v88@gmail.com>
To: Alexander Popov <a13xp0p0v88@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Lars-Peter Clausen <lars@metafoo.de>,
        Arnd Bergmann <arnd@arndb.de>, Anatolij Gustschin <agust@denx.de>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/8/3 Gerhard Sittig <gsi@denx.de>:
> On Wed, Jul 31, 2013 at 11:20 +0400, Alexander Popov wrote:
>>
> Please make sure to either cite
> properly or to properly mark changes as such.  Don't spread false
> information, please.  You are free to change what I submitted,
> but you should not pretend that I wrote what has become of the
> code after you have modified it.  Please fix the attribution.

Excuse me for the confusion.
I'll be careful with "From:" notes.

> Just to clarify:  The defines here appear to be more appropriate
> than the initial enums, after it turned out that we need not
> handle indiviudal channels in special ways, and really only need
> these three numbers (one of them being the maximum of the
> others).  But regardless of what you have changed, you should
> clearly state the fact.

Ok, I'll do so.

Best regards,
Alexander.
