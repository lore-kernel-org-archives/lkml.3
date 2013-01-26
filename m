Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab3AZNbq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 08:31:46 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61105 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab3AZNbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 08:31:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCHv2 00/19] ARM: common warning fixes
Date: Sat, 26 Jan 2013 13:31:40 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-1-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1359123276-15833-1-git-send-email-arnd@arndb.de> <1359153858-31992-1-git-send-email-arnd@arndb.de> <20130126100542.GC23505@n2100.arm.linux.org.uk>
In-Reply-To: <20130126100542.GC23505@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301261331.40932.arnd@arndb.de>
X-Provags-ID: V02:K0:JF+W6tdH3SXMBvIoBq6Ed6dgGa8Lwc0/3z70QB3tb1F
 DxIV0T4PFoiSyYNMS7keAbkcDF3edkxyZWJfBOAB0LcVQDrVRI
 g679H7+HcaISqiFtXAT1HCQvefYMuGX87DAYW+VgUbX4OTGud0
 BP9ouh7iYA97EaAIpsY5Jhr4BpgoGBhoKQHbuyIl5TgNQ9WsR/
 j8PowopdfMp7rF5Z9c3XYM7933vF1XKFT8JHiGI/UI/IPEyRhH
 /dVuHQv7PPNiDh6P5QNvIcBClLVInY+f1ChUkMFpBz87JPVmL2
 4cKaeqAccKbkXcg19sEj1cL8YlRGd+Mo3XbqeRrXsb01diErDh
 PRpvYjpvHJclYKtYHZK0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 January 2013, Russell King - ARM Linux wrote:
> On Fri, Jan 25, 2013 at 10:43:59PM +0000, Arnd Bergmann wrote:
> > I will get to those once this series is sorted out.
> > Since there are no interdepencies between the patches,
> > my preference is to have them applied by the individual
> > subsystem maintainers. Anything that has not at
> > least made it into linux-next by the next merge window
> > and has not received a 'NAK' or been obsoleted by
> > another patch, I plan to submit as part of an arm-soc
> > branch for 3.9.
> 
> And, last night we have new warnings.  My allnoconfigs no longer build
> cleanly because of new vexpress section mismatches in the mfd code.

Yes, I already sent a patch yesterday. The problem was a regression
that came in through the arm-soc tree unfortunately, but I can easily
fix it then.

> It seems to me that you're on a loosing battle unless you test the tree
> and drop code before propaging it out if it adds new warnings... force
> the pain of these warnings down on to others so that they learn to create
> better code in the first place.

That was always the idea, right now I mainly try to get back to the almost
clean state I had some time ago.

The largest problem right now is gcc-4.7, which adds a lot of new bogus
warnings.

	Arnd
