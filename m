Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936393Ab3DIUie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:38:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54002 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936180Ab3DIUiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:38:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 5/8] dmaengine: ste_dma40: Ensure src and dst registers are configured correctly
Date: Tue, 9 Apr 2013 22:38:07 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
References: <1365532783-27425-1-git-send-email-lee.jones@linaro.org> <201304092057.29684.arnd@arndb.de> <20130409190916.GF25316@gmail.com>
In-Reply-To: <20130409190916.GF25316@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201304092238.07286.arnd@arndb.de>
X-Provags-ID: V02:K0:Cb7c04oOzHJgH4EPW4vVx5VcN0x0aj8CsVLxF6ekZ6/
 9AyiJd1TH7d2TloOrcQj+AasMPrhbfxg19CkD8gYK5GZIFcqkj
 WGckopmRd3n2OTH7Qdhz08yX75arNHiZWtUUZ2CmmRULgy5wb9
 snItIB80jg7CqYGRLPTAdbrAJsSAFswzKAKpZghYH0UdkNjOkk
 zOQgCTSInXlB1I/093Zi293yDuuqSAEqxop9h/5sEu4HGU64ns
 jd3j4OmmmtaZHsBZjlfzKK2vOzJE2JCvYUB9YITu0vmrbDOOj/
 3WLFh/ZxukzbWvnIi5xNQZG1RTZ9MOW271CXLUAgqQj+bhA+Lm
 iR4hzeqWyMg4NDXgvupY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 April 2013, Lee Jones wrote:
> On Tue, 09 Apr 2013, Arnd Bergmann wrote:
> 
> > On Tuesday 09 April 2013, Lee Jones wrote:
> > > Confusingly d40_log_cfg() is used to set up the logical channel
> > > configuration registers, but d40_phy_cfg() is used to configure
> > > physical and logical registers, so it should be called in both
> > > cases. It is the function call's final attribute which determines
> > > whether it's a physical or logical channel, not whether the
> > > function is called or not.
> > 
> > So how did it ever work? Your description sounds like it was
> > broken all along, but I would assume that someone tested the code.
> 
> From what I can see, not.
> 
> My best guess is that the 'test' was to see if the configuration
> changed using the debug print at the end of the function. I don't see
> how else the configuration can be written to hardware.

Acked-by: Arnd Bergmann <arnd@arndb.de>
