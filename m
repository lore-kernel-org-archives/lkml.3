Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbaHHBB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 21:01:26 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:48937 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079AbaHHBBY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 21:01:24 -0400
From: Paul Moore <paul@paul-moore.com>
To: David Miller <davem@davemloft.net>
Cc: geert@linux-m68k.org, linux-security-module@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sel_netif_init: 'err' is used uninitialized
Date: Thu, 07 Aug 2014 21:01:19 -0400
Message-ID: <5275439.odfNAhPpkP@sifl>
User-Agent: KMail/4.13.3 (Linux/3.15.7-gentoo; KDE/4.13.3; x86_64; ; )
In-Reply-To: <20140807.120454.1646328149054855088.davem@davemloft.net>
References: <CAMuHMdV4VpaH1nHYO5hr66Xib5o_Pib863JzGRtg2kYcjMp2TQ@mail.gmail.com> <5750080.46d2jsPKXX@sifl> <20140807.120454.1646328149054855088.davem@davemloft.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 07, 2014 12:04:54 PM David Miller wrote:
> From: Paul Moore <paul@paul-moore.com>
> Date: Thu, 07 Aug 2014 10:26:14 -0400
> 
> > On Thursday, August 07, 2014 12:31:15 PM Geert Uytterhoeven wrote:
> > 
> >> 
> >> security/selinux/netif.c: In function ‘sel_netif_init’:
> >> /scratch/geert/linux/linux-m68k/security/selinux/netif.c:285: warning:
> >> ‘err’ is used uninitialized in this function
> >> 
> >> Should it just return 0, like before?
> >> Or should it return the return value of register_netdevice_notifier()
> >> instead, which also returns an error code? Or is that failure
> >> non-critical?
> > 
> > Hi,
> > 
> > I posted a fix for this two days ago to the SELinux list (see below).  As
> > soon as -rc1 is released and linux-next is back in business I'll be
> > pushing the patch to the SELinux #next branch.
> > 
> >  * http://marc.info/?l=selinux&m=140727033030054&w=2
> 
> With respect to this and the lack-of-inline warning fix we spoke about
> yesterday, why are you waiting and only pushing such bug fixes into your
> "next" branch?

Simply put, I didn't think the patches were significant enough to push at this 
point in time.
 
> Those sort of things should be sent to Linus now to correct the errors
> introduced during the merge window, as I have done last night for all
> of the networking merge fallout.

I'll (re)post the patches with a pull request in just a moment, CC'ing all the 
various mailing lists and you guys can figure out who best to merge them.

-- 
paul moore
www.paul-moore.com

