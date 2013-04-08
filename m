Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936017Ab3DHM5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 08:57:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935703Ab3DHM5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 08:57:03 -0400
Date: Mon, 8 Apr 2013 09:56:52 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Prabhakar lad <prabhakar.csengg@gmail.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 0/2] ARM: davinci: dm355: add support for vpbe
 display
Message-ID: <20130408095652.33dcb0be@redhat.com>
In-Reply-To: <5162AE56.5090203@ti.com>
References: <1365413215-3632-1-git-send-email-prabhakar.csengg@gmail.com>
	<51629DA8.3040806@ti.com>
	<20130408075606.5a59d32c@redhat.com>
	<5162AE56.5090203@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 8 Apr 2013 17:17:34 +0530
Sekhar Nori <nsekhar@ti.com> escreveu:

> Hi Maruo,
> 
> On 4/8/2013 4:26 PM, Mauro Carvalho Chehab wrote:
> > Hi Sekhar,
> > 
> > Em Mon, 8 Apr 2013 16:06:24 +0530
> > Sekhar Nori <nsekhar@ti.com> escreveu:
> > 
> >> On 4/8/2013 2:56 PM, Prabhakar lad wrote:
> >>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> >>>
> >>> This patch series enables VPBE display driver on DM355.
> >>
> >> These (this and the DM365 one) patches look good to me. I need to get an
> >> immutable branch from Mauro where dependencies are queued and then I can
> >> generate a pull request for these for ARM SoC.
> > 
> > Are you mean a branch at the media development tree for you to sent
> > pull requests for me? If so, just use the "master" branch at the media
> 
> The pull request will be sent to my upstreams (ie the ARM SoC folks -
> Arnd and Olof). Since the platform data patches need driver patches to
> be applied first, I need a non-rebasing branch containing the driver
> stuff which I can use a dependency and apply platform patches on top.

Hmm... I generally wait for arch patches to be applied first, before
sending driver patches. If you're willing to do that, I suggest that
Arnd/Olof should put those patches on a separate topic branch, and
sending an upstream pull request for them after mine.

If the patches are trivial, maybe the better would be to put both
media and arm patches at the same tree, with the other maintainers'
ack.

> 
> > tree:
> > 	http://git.linuxtv.org/media_tree.git
> > 
> > The master branch there is never rebased. I'll likely start to have
> > topic branches on the next Kernel cycle, also at the same tree.
> 
> Ideally I will use the immutable branch which you will also use to send
> pull request to Linus so there are not unnecessary merge conflicts. When
> will those branches be ready?

I use a tree at Kernel.org for Linus submission. I only pull the patches
there when I'm about to ask him to pull, and after being sure that those
patches were already successfully merged at -next tree for some time.
So, you should not base your tree there, as it will have there only the 
patches that I already submitted.


Regards,
Mauro
