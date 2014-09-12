Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaILUvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 16:51:11 -0400
Received: from parrot.pmhahn.de ([88.198.50.102]:52177 "EHLO parrot.pmhahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbaILUvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 16:51:08 -0400
X-Greylist: delayed 517 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Sep 2014 16:51:07 EDT
Date: Fri, 12 Sep 2014 22:42:28 +0200
From: Philipp Matthias Hahn <pmhahn@pmhahn.de>
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RFH: How to correctly request a back-port / cherry-pick for stable
 3.10?
Message-ID: <20140912204228.GA8004@pmhahn.de>
Mail-Followup-To: Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've found and debugged a problem in 3.10.54, which is fixed by
commit 8915aa27d5efbb9185357175b0acf884325565f9, which is in 3.11.

I'd like to request the commit being cherry-picked into 3.11, but
reading Documentation/stable_kernel_rules.txt confuses me, as all my
previous attempts seem to not having worked:

> - Send the patch, after verifying that it follows the above rules, to
>   stable@vger.kernel.org.  You must note the upstream commit ID in the
>   changelog of your submission, as well as the kernel version you wish
>   it to be applied to.

So do I need to do the cherry-pick myself?

Amending the commit message by adding 
  commit 8915aa27d5efbb9185357175b0acf884325565f9 upstream.
between the subject line and the patch description is the easy part.

Where should the "kernel version" go? Looking at
<https://www.kernel.org/pub/linux/kernel/v3.x/ChangeLog-3.10.54> that
information is not part of any commit message.
Should it go after the 1st "---"?

> - To have the patch automatically included in the stable tree, add the tag
>     Cc: stable@vger.kernel.org
>   in the sign-off area. Once the patch is merged it will be applied to
>   the stable tree without anything else needing to be done by the author
>   or subsystem maintainer.

As the patch is already in 3.11, that doesn't seem to apply for
requesting a back-port.

> - The sender will receive an ACK when the patch has been accepted into the
>   queue, or a NAK if the patch is rejected.  This response might take a few
>   days, according to the developer's schedules.

So far I have receiver nothing, only silence.

> - If accepted, the patch will be added to the -stable queue, for review by
>   other developers and by the relevant subsystem maintainer.

and I don't find it there.

Can somebody please give me a hint on what I'm missing or doing wrong?
An example email containing such a back-port request would be very much
appreciated.

Thanks.

Philipp
-- 
  / /  (_)__  __ ____  __ Philipp Hahn
 / /__/ / _ \/ // /\ \/ /
/____/_/_//_/\_,_/ /_/\_\ pmhahn@pmhahn.de
