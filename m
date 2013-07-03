Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab3GCHcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 03:32:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53317 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab3GCHcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 03:32:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [GIT PULL 3/7] ARM SoC specific changes
Date: Wed, 3 Jul 2013 09:31:38 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
References: <201307022055.50717.arnd@arndb.de> <201307022104.01826.arnd@arndb.de> <20130702231706.GF24642@n2100.arm.linux.org.uk>
In-Reply-To: <20130702231706.GF24642@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307030931.39043.arnd@arndb.de>
X-Provags-ID: V02:K0:lRIpYuHTa7PaTjeUbD44OuhhoDlZTn4mZ6Y15Sci7EG
 4huOdd73mI6jONxyIxJ5fmDFpNsCnIJcCw4ZiTc/38ifH98PHz
 qxkA2sVQGMtiRM9G+v+x1f3XcMi3P0tOftRU8A2xmxJ8XsBlkb
 Mki1clmoRp34Pgw1X/O39SwjqshgCspRWyHZjop1g7pQU2ilPS
 02UK6LUSfnAcreLJWM+y92mVdGK8eVvctNCN6DJ2nPNr8o5Lej
 bCtOlsz7SL4a9v5ThIF6PNiCl6fdbxgVuFAdboLqESP448z0jX
 I71nm6CEtvlnc43fWjMTkX9hCPlL58OuJdsLX05wag/+baVBIf
 cbuk7I+3bXBhtinumGEs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 July 2013, Russell King - ARM Linux wrote:
> Please don't merge this yet.
> 
> Arnd has just done the worst possible thing - the arm-soc tree has taken
> bits of my tree, merged them into their own tree, had the same conflicts
> I've had, and then resolved them differently.
> 
> The result is that when these two trees now merge, they conflict on the
> conflict resolutions.  This is utter madness.

I assume you mean the confict in arch/arm/include/asm/glue-proc.h, right?

I'm sorry I did not realize that the conflict was between a commit
from your tree and from v3.10, otherwise I would have waited for your
pull request to come first.

I did the merge in my latest for-next branch, but not in the branches
that I sent off to Linus, instead I describe the conflict and Linus
picked one of the two possible resolutions. Unfortunately it was the
one I had, not yours, so he will get the conflict between the merges
again when he pulls your tree. I don't think there is any good way
to avoid that now, but since Linus now knows about the conflict it
at least won't be hard for him to figure out the solution, in this
case by using your version of the file.

	Arnd
