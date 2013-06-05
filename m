Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002Ab3FEVwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:52:33 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:56589 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932929Ab3FEVwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:52:30 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Luke Kenneth Casson Leighton <lkcl@lkcl.net>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        debian-kernel@lists.debian.org
Subject: Re: getting allwinner SoC support upstream (was Re: Uploading linux (3.9.4-1))
Date: Wed, 05 Jun 2013 23:52:26 +0200
Message-ID: <19865137.ey1FePPnmD@flatron>
User-Agent: KMail/4.10.4 (Linux/3.9.4-gentoo; KDE/4.10.4; x86_64; ; )
In-Reply-To: <CAPweEDzDC87KmOQ=0hyPcjPtPsRuXHxNTs97vbEqVNNnix69rA@mail.gmail.com>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com> <CAKON4OxDD5orX2w-_+d5kawTGXbE3KKj2QLERo9m7=NiUSXhgQ@mail.gmail.com> <CAPweEDzDC87KmOQ=0hyPcjPtPsRuXHxNTs97vbEqVNNnix69rA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luke,

On Wednesday 05 of June 2013 22:15:08 Luke Kenneth Casson Leighton wrote:
> [i've just received word, please remove debian-release from
> discussions!]
> On Wed, Jun 5, 2013 at 9:46 PM, jonsmirl@gmail.com <jonsmirl@gmail.com> 
wrote:
> > Why don't you try converting the sunxi code over to device tree?
> 
> ok.  perhaps i wasn't clear.  whatever is proposed has to be be
> acceptable to allwinner, and i'm looking for proposals that i can put
> to them, i.e. i am going to act as the communications channel to them.

Well, device tree is the only method of hardware description supported by 
Linux kernel on ARM at the moment (except for board files, but this is 
deprecated). I don't see why it should change, considering the fact that 
device tree is generic, extensible and described by standards. There is no 
place for any proprietary solutions here.

> what we do not want to happen is that they see upstream patches being
> submitted, they merge them into their internal tree (which to date has
> had zero upstream changes: they're currently only just getting round
> to doing 3.4 as we speak), and they *completely* ignore *absolutely
> everything* that's being done by the community, duplicating yet
> another set of device drivers (named drivers/*/sun8i_* and so on).

This is mostly their problem. If they don't care about work duplication on 
their side then why bother?

> > I don't
> > think it will be as hard as you may think it is. Start off by mapping
> > the existing fex syntax into a DTS file. Send your DTS file to
> > devicetree-discuss to get help with the correct syntax. Once this DTS
> > template is constructed you can write a program to convert any fex
> > file into it.
> 
>  this proposal is a start: however what you have to bear in mind is
> that you now have to convince a very busy company that it is in their
> best interests to disrupt their schedule, to drop their existing
> working practices, to tell all their customers "please stop using the
> existing tools and please use these ones instead".

I'm not sure if I followed all the discussion (read 
http://thread.gmane.org/gmane.linux.debian.devel.kernel/91136/focus=92096 
which didn't seem to contain anything relevant), so I might not have the 
full picture, but I'm going to put my two cents in.

I tend to disagree with your view. Is it really our task to convince such 
companies to work with open source community? If they don't see the 
benefit of doing so, then IMHO it's their loss and loss of their customers 
and end users. There are so many vendors backing open source at the moment 
and they somehow don't have problems like this.

>  you also need to convince the creators of the proprietary
> firmware-flashing tools "livesuite" and "phoenix" to *also* convert
> their tools over to the new proposed idea.
> 
>  so if that is to truly be accepted, it has to be framed in such a way
> that it will be clearly of financial benefit to the SoC vendor.
> 
>  can you provide such a supporting argument which would convince
> allwinner to accept the modifications to their working practices that
> you propose?

There is one, very simple. If they don't, there is no community 
cooperation for them, that's how it works. There is a set of unwritten (or 
maybe even written) rules of open source communities that you must obey if 
you want to work with them and you can't just get over that, because some 
company don't want to change their practices.

Just see how many companies are backing open source at the moment, without 
making problems like this. They have understood the benefits and taken the 
effort to change their practices, because it was worth it. (I'm working 
for such company at the moment and I can assure you that this is the 
case.)

> > Device tree on ARM's goal is to achieve a single kernel across
> > vendors, not just a single kernel for a single vendor.
> 
>  you'll be aware that i've mentioned a number of times and have
> discussed at some length why this is a goal that is completely
> impossible to achieve [*1].  sadly.

I tend to disagree on this as well, but it's another story. Have read one 
of the discussions on this topic and it seemed to look more like lobbying 
for one of the standards being promoted by some company, not anything 
really close to the reality (where we can already successfully run 
multiplatform kernels on platforms of different vendors...).

Best regards,
Tomasz

