Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbaHSSnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 14:43:17 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:63782 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbaHSSnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 14:43:14 -0400
Date: Tue, 19 Aug 2014 11:43:03 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: Overriding -Werror
Message-ID: <20140819184303.GT18411@ld-irv-0074>
References: <20140814222119.GD18411@ld-irv-0074>
 <87ppfwmxic.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ppfwmxic.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 06:15:07AM -0700, Andi Kleen wrote:
> Brian Norris <computersforpeace@gmail.com> writes:
> >
> > 4. better ideas?
> 
> Just send patches to remove -Werror in all architectures
> as a tree sweep (and anywhere else where someone misguided add it)

I cited at least one example in which this was attempted but rejected.
(Or at least, it was semi-deliberately stalled.)

> Having -Werror anywhere in a shipping release is just plainly a bug,
> as it makes it often impossible to build on newer gcc versions.

I also feel it is misguided, for other reasons. But there are at least a
few who seem to disagree. They seem to feel it is important/necessary
for enforcing good practices during development. I'm not sure how to
bridge the disagreement, other than to provide workarounds for disabling
-Werror.

I could try sending -Werror removal patches, but I'm not confident that
will go over well.

Brian
