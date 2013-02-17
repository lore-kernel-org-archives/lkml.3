Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab3BQOBo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 09:01:44 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:53584 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271Ab3BQOBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 09:01:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 02/11] ARM: samsung: fix assembly syntax for new gas
Date: Sun, 17 Feb 2013 14:01:27 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ben Dooks <ben-linux@fluff.org>,
        stable@vger.kernel.org
References: <1360849767-1463135-1-git-send-email-arnd@arndb.de> <1360849767-1463135-3-git-send-email-arnd@arndb.de> <20130216232550.GQ17833@n2100.arm.linux.org.uk>
In-Reply-To: <20130216232550.GQ17833@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302171401.27667.arnd@arndb.de>
X-Provags-ID: V02:K0:2RzBcCkiqAtlymvqbgxI3CqBVeZJEz9O9Eabh7Giazc
 wcihY1trnSYIlbcE4G0IRlGlm7ydGZiakQxjaEt9HC3F5cEj32
 3yx+Sw0mLqgV8fD2QmpBbtxFz+PYh0BJfGli9v+kQNgNgYZAQN
 C/arjk2GuO3hH81ueSa26ker+NXU16+u/gS80Hd8OTjocTnMaG
 yRi+oMYopS26r1EyDjh03lse6m8uY66V9xyTTNI5Zd/YNc4ymu
 dqRwox6CLoydgio4ijf8rMzRtXJy5PzSk9F0LhTAHDV+rB28B8
 U37mbxht1CM0yeaCAgG565kXFWOQetvd4b2iNWSe3IV+GMD9FR
 /+CPpuUrFcR5f/idSBAM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 February 2013, Russell King - ARM Linux wrote:
> On Thu, Feb 14, 2013 at 02:49:18PM +0100, Arnd Bergmann wrote:
> > Recent assembler versions complain about extraneous
> > whitespace inside [] brackets. This fixes all of
> > these instances for the samsung platforms. We should
> > backport this to all kernels that might need to
> > be built with new binutils.
> 
> I hope that's also been reported as a bug to the binutils people.

No, I did not think of that. There were a lot of bug reports for
similar issues and I assumed that there was a good reason for
the change, but I agree that it sounds like a regression, especially
since the code that triggers the error should not be ambiguous and
there was never a warning about it.

	Arnd
