Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbaJXIbG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 04:31:06 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:58191 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaJXIbB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 04:31:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Michal Simek <michal.simek@xilinx.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] MAINTAINERS: Add myself as reviewer for Zynq
Date: Fri, 24 Oct 2014 10:30:54 +0200
Message-ID: <1905062.WThGHQej1A@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <93a573b450ca429cad3ba42f875880d7@BL2FFO11FD051.protection.gbl>
References: <1414081762-28886-1-git-send-email-soren.brinkmann@xilinx.com> <93a573b450ca429cad3ba42f875880d7@BL2FFO11FD051.protection.gbl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:xwdUvhKya2jXbapW8QnhiTMNe7xTnVagOAXJCBDAo1H
 a0qYEkK9veFJi3jC7lKYpYPCVpDMPGMIVi3pn0qd6TsyWlb9rg
 LyMcv2J54gJNi2vy+9hqS5sBuuRnhTGbBnShxql9v53drSKXwJ
 mahnkiU9M1f4aSgBEvCN8V7n5romSsuY7MJxa9aX+WZLTKSoYS
 p45KCt7LAsEFrL0LIQ4RtVWwgxBFxfnppSHga+bubRn27kw27a
 B3jspTZ2C6uSZSDB9G54v2xwEkFcNi+2IolbHv1csbbEF6Cb8U
 C9m8v5SEDKcP6bT3R5tk0LadeKrKCTd03VUk2PvORLhKZtZEjZ
 LxYLXvamV8iLNm69ADZ4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 October 2014 08:08:15 Michal Simek wrote:
> On 10/23/2014 06:29 PM, Soren Brinkmann wrote:
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> > v2:
> >  - I removed the additional 'F' entries
> > 
> >  MAINTAINERS | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 0484f2c526f0..8b49eeee5a27 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -1543,6 +1543,7 @@ F:      arch/arm/mach-pxa/include/mach/z2.h
> >  
> >  ARM/ZYNQ ARCHITECTURE
> >  M:   Michal Simek <michal.simek@xilinx.com>
> > +R:   Sören Brinkmann <soren.brinkmann@xilinx.com>
> >  L:   linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> >  W:   http://wiki.xilinx.com
> >  T:   git git://git.xilinx.com/linux-xlnx.git
> > 
> 
> Applied.
> IMHO: This can go through arm-soc tree.

Yes, a simple patch like this, you can forward to use with your
Signed-off-by, or add an Ack and ask us to pick it up directly.

With the current timing, I can still pick it up as a fix for 3.18 if you
like.

	Arnd
