Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab3IRPHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 11:07:17 -0400
Received: from helium.waldemar-brodkorb.de ([89.238.66.15]:45829 "EHLO
	helium.waldemar-brodkorb.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751692Ab3IRPHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 11:07:15 -0400
Date: Wed, 18 Sep 2013 17:07:13 +0200
From: Waldemar Brodkorb <wbx@openadk.org>
To: Andrea Adami <andrea.adami@gmail.com>
Cc: Waldemar Brodkorb <wbx@openadk.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: problem booting linux with qemu-system-arm -M spitz
Message-ID: <20130918150713.GK14246@waldemar-brodkorb.de>
Reply-To: Waldemar Brodkorb <mail@waldemar-brodkorb.de>
References: <20130918102701.GJ14246@waldemar-brodkorb.de>
 <CAAQYJAv+rUiv5=qnL74WR9gFzv84SCwPcTNRcJcMcR8+pf75BQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAAQYJAv+rUiv5=qnL74WR9gFzv84SCwPcTNRcJcMcR8+pf75BQ@mail.gmail.com>
X-Operating-System: Linux 3.2.0-4-amd64 x86_64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Andrea Adami wrote,

> On Wed, Sep 18, 2013 at 12:27 PM, Waldemar Brodkorb <wbx@openadk.org> wrote:
> > Hi Kernel hackers,
> >
> > I am trying to run Linux on Qemu/arm emulator with machine type
> > spitz. In the past this worked fine.
> > Now with Linux version 3.9.11 it does not boot anymore.
> > (blank screen, no kernel messages)
> >
> > I used git bisect to find the commit, which breaks the boot:
> > commit 4e8ee7de227e3ab9a72040b448ad728c5428a042
> > Author: Will Deacon <will.deacon@arm.com>
> > Date:   Wed Nov 23 12:26:25 2011 +0000
> >
> > I am using Qemu 1.6.0 on a Debian/x86_64 host.
> >
> > Any help would be appreciated.
> >
> > Thanks in advance
> >  Waldemar
> >
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
> On real hardware I see the same breakage after 3.2.
> Marko diagnosed it and there is a pending patch:
> 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-September/198444.html
> 
> There is indeed some MMU-related issue.
> Probably the function could be called elsewhere during machine init
> but I'm not so high in the food chain to dare to touch arm boot code
> ;)
> 
> Regards

Great! Thank you very much, this works fine.

best regards
 Waldemar
