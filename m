Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbaJ1U5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 16:57:50 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:53171 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378AbaJ1U5r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 16:57:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?ISO-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
Subject: Re: [PATCH v2] MAINTAINERS: Add myself as reviewer for Zynq
Date: Tue, 28 Oct 2014 21:57:39 +0100
Message-ID: <31125258.WF8sFMxyCQ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <f506a31d4f3b47f7aa3d08cc653a0de5@BY2FFO11FD041.protection.gbl>
References: <1414081762-28886-1-git-send-email-soren.brinkmann@xilinx.com> <2e0177fec3e14239ba979cbc5e924a73@BN1BFFO11FD026.protection.gbl> <f506a31d4f3b47f7aa3d08cc653a0de5@BY2FFO11FD041.protection.gbl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:MoGB0wP35SMhm+GEiG5gcaiyVcySU1Wv7IPI+BIje1y
 Ex943IJEbJ742/3iC/QnKmC6E+UTvgCcJOg5SqfouBrZzSPYRh
 M2R3z6J/40sa9pma4hhvtlJetRh3M1q+P/7nPLBoWqj5uxgqbU
 f2xOgN+S/76r9HFXKDrtGy70zNzA+l8Wy4ldtcdC2JmG9HRl7T
 901+n8Ens6nk17XSjznbWOaKLQIhcUUnJrDnshrQmSuhd2skCi
 1N4gpmCtUoOs+PHm3UStRgC7XRE6Mc0qeCbRPWXXvjICXx9jrA
 O9QMxfLBoJnUQK5koUV4ScEFNgYJGO6nII1rkqqYj4V2DM5j2p
 gNaqLnE44zgjMp4EjR1Q=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 October 2014 10:49:50 Sören Brinkmann wrote:
> On Fri, 2014-10-24 at 10:45AM +0200, Michal Simek wrote:
> > On 10/24/2014 10:30 AM, Arnd Bergmann wrote:
> > > On Friday 24 October 2014 08:08:15 Michal Simek wrote:
> > >> On 10/23/2014 06:29 PM, Soren Brinkmann wrote:
> > >>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > >>> ---
> > >>> v2:
> > >>>  - I removed the additional 'F' entries
> > >>>
> > >>>  MAINTAINERS | 1 +
> > >>>  1 file changed, 1 insertion(+)
> > >>>
> > >>> diff --git a/MAINTAINERS b/MAINTAINERS
> > >>> index 0484f2c526f0..8b49eeee5a27 100644
> > >>> --- a/MAINTAINERS
> > >>> +++ b/MAINTAINERS
> > >>> @@ -1543,6 +1543,7 @@ F:      arch/arm/mach-pxa/include/mach/z2.h
> > >>>  
> > >>>  ARM/ZYNQ ARCHITECTURE
> > >>>  M:   Michal Simek <michal.simek@xilinx.com>
> > >>> +R:   Sören Brinkmann <soren.brinkmann@xilinx.com>
> > >>>  L:   linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> > >>>  W:   http://wiki.xilinx.com
> > >>>  T:   git git://git.xilinx.com/linux-xlnx.git
> > >>>
> > >>
> > >> Applied.
> > >> IMHO: This can go through arm-soc tree.
> > > 
> > > Yes, a simple patch like this, you can forward to use with your
> > > Signed-off-by, or add an Ack and ask us to pick it up directly.
> > > 
> > > With the current timing, I can still pick it up as a fix for 3.18 if you
> > > like.
> > > 
> > 
> > Ok here is my
> > Acked-by: Michal Simek <michal.simek@xilinx.com>
> > 
> > and please pick it up as fix directly to 3.18.
> 
> Thanks!

Added to fixes branch.

I've changed the subject line to "Add Soren as reviewer for Zynq",
since even though you are the author of the patch, that is a more
useful shortlog message.

	Arnd
