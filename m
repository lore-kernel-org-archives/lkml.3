Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057Ab3FFIZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 04:25:34 -0400
Received: from 11.mo1.mail-out.ovh.net ([188.165.48.29]:57190 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757892Ab3FFIZY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 04:25:24 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: getting allwinner SoC support upstream (was Re: Uploading linux (3.9.4-1))
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
In-Reply-To: <CAPweEDzCCONQfzdzPrP3jtr-sPg3t2aq4pdk6Fy0Ko37B9RwmA@mail.gmail.com>
Date: Thu, 6 Jun 2013 10:16:15 +0200
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org, "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        ARM Linux Mailing List <linux-arm-kernel@lists.infradead.org>,
        debian-kernel@lists.debian.org
Content-Transfer-Encoding: 8BIT
Message-Id: <C08D6DCD-B273-4D38-8C4E-C81D8BF461A8@jcrosoft.com>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com> <CAKON4OxDD5orX2w-_+d5kawTGXbE3KKj2QLERo9m7=NiUSXhgQ@mail.gmail.com> <51AFA6DD.3000202@wwwdotorg.org> <20130605211637.GH18614@n2100.arm.linux.org.uk> <CAPweEDzCCONQfzdzPrP3jtr-sPg3t2aq4pdk6Fy0Ko37B9RwmA@mail.gmail.com>
To: Luke Kenneth Casson Leighton <lkcl@lkcl.net>
X-Mailer: Apple Mail (2.1503)
X-Ovh-Tracer-Id: 4996462313678351202
X-Ovh-Remote: 90.37.12.95 (amarseille-152-1-106-95.w90-37.abo.wanadoo.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -51
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrfeeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogfuuhhsphgvtghtffhomhgrihhnucdlgeelmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -51
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrfeeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogfuuhhsphgvtghtffhomhgrihhnucdlgeelmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 6, 2013, at 12:07 AM, Luke Kenneth Casson Leighton <lkcl@lkcl.net> wrote:

> [ please do try to remove debian-release from replies - my mistake
> please try not to propagage it, even though it may be too late!]
> 
> On Wed, Jun 5, 2013 at 10:16 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> 
> eyy, allo russell, long time since we last spoke, which was eek around
> 2004 for that cirrus logic 90mhz ARM when i was converting skyguard
> over from 2.4 to 2.6.
> 
>> On Wed, Jun 05, 2013 at 03:00:13PM -0600, Stephen Warren wrote:
>>> 2) Having U-Boot itself read a DT and configure itself, just like the
>>> kernel does. This is relatively new, and only supported by a few boards
>>> (all Tegra to some extent, and a couple each Samsung Exynos and Xilinx
>>> boards). I suspect/guess this is the kind of thing that Luke was
>>> referring to re: U-Boot fex integration.
>> 
>> Reading what I have of this thread, this is just another case of
>> $company runs of and does their own unique way of doing something,
> 
> he he - don't be too despondent, russell: they've managed to be
> incredibly successful, and they're a young company, my role here is to
> act as the go-between, to be able to say to them "can we help each
> other out here please?"
> 
>> which is in a totally different direction from that path chosen by
>> Linux kernel developers, and Linux kernel developers are _expected_
>> to roll over and accept $company's unique way of doing it.
> 
> not at all.  no.  definitely wrong.  you're thinking about this the
> wrong way.  i.e. you're imagining that they have some sort of agenda
> which is to punish linux kernel developers.
> 
> the sunxi community however - those of us who have to act as
> piggy-in-the-middle - those of us who are working directly with the
> linux-sunxi kernel tree - are torn between going:
> 
> * damnit let's give those linux kernel developers a damn good kicking
> for setting silly rules!
> * oh blast.  not a snowball in hell's chance of getting allwinner soc
> code upstream
> * i wonder if there's a diplomatic solution or a well-reasoned argument here
> 
> and so on.
> 
> allwinner?  naah.  they'll quite happily keep on taking linux 3.4,
> 3.5, 3.20e6 source code and forking it and throwing it back out there
> until the heat death of the universe reaches zero.... all without
> *ever* having expected a *single* linux kernel developer to roll over
> any object of their personal choosing.
> 
>> $company could have assisted with the DT effort, helping to sort out
>> the common arch issues (which haven't been all that much), converting
>> drivers to DT and such like.  But no, instead they've gone off and
>> created their own thing.
> 
> yes, for very very good reasons, i feel.  they have different
> requirements and different goals from the stated [unachievable but
> quite laudable one-kernel-fits-all-ARM-SoCs-everywhere] goal that the
> linux kernel developers have set themselves.
> 
> 
> * the markets that allwinner are targetting  [their own SoCs in the
> tablet and IPTV markets] are very much a subset of those which the
> linux kernel developers are targetting [every single ARM SoC and every
> single product based around ARM SoCs in existence, past present and
> future].
> 
> * the file format is standard DOS .INI format, so their customers,
> instead of having to edit c code or understand DT, can just use a DOS
> editor.  remember: these devices are often being made by people who
> decided "i'm fed up of selling socks, jumpers and handbags: i know, i
> fink i will diversify and get my girls to make.... tablets. yes,
> that's it!  tablets!".  so now you know what level of technical
> computing competence most of these factories have: NONE.  it's amazing
> that they sell anything at all, to be honest, but sell they have, and
> taken 40% world-wide market share of the tablet market.
> 
> * the ODMs can take virtually any device, from any customer,
> regardless of the design, put *one* [unmodified, precompiled] boot0,
> boot1, u-boot and kernel onto it, prepare the script.fex easily when
> the customer has been struggling on how to start that DOS editor he
> heard about 20 years ago, and boot the device up, put it into a
> special mode where the SD/MMC card becomes a JTAG+RS232 and see what's
> up... all without even removing any screws.
> 
>> I wonder how many more of these cases there needs to be before people
>> get the message that Linux kernel developers *do* *not* like this
>> behaviour, and if you do this, then chances are you're going to be
>> stuck with having code which isn't able to be merged into mainline.
> 
> well... then the SoC vendor with a global market share totalling 40%
> will carry on creating yet more code which isn't able to be merged
> into mainline, and they won't give a flying fuck, russell - simple as
> that.  actually, they won't even give a flying fuck, they'll just
> carry on happily making money.
> 
> and the sunxi community, who are stuck in the middle, will be forced
> to shoulder the burden of the work in living between these two worlds.
> 
> plus, because debian and the many other linux distros only really
> accept code from upstream rather than from self-appointed communities
> (because it's damn inconvenient to do merging for just one SoC e.g. in
> debian where they have *mostly* a multi-arch kernel i.e.
> multi-minus-allwinner), the sunxi community will... no, actually, they
> won't be burdened with that task, they'll just continue to advise
> people where various people have created non-packageable versions of
> the linux kernel, usually distributed as part of some god-awful
> instructions that include "now download a 1gbyte pre-prepared root
> filesystem from dropbox.com" - i'm exaggerating there but only
> slightly.
> 
> ... am i making it clear that this is a dog's dinner mess, and setting
> intransigent rules only hurts the end-users and reduces the acceptance
> and availability of linux distros?
> 
>> And I don't buy the argument that we were still sorting out DT.  DT has
>> been well defined for many many years before we started using it on ARM.
>> It has been used for years on both PowerPC and Sparc architectures to
>> describe their hardware, and all of the DT infrastructure was already
>> present in the kernel.  What was left for us were:
>> 
>> * converting our platform-data based drivers to use data from DT.
>> * come up with ways of dealing with SoC issues such as clock
>>  representation, pin muxing and such like in DT.
> 
> yes.  "what was left".  in other words, when allwinner would have
> been looking at this, they would have gone, "we can't possibly deal
> with this.  none of us speak english.  we have to get a simple-to-use
> bootstrap system out there, including something equivalent to a BIOS
> all customisable *without* any recompiles... we have to do this
> ourselves and we have to get it out *now*, not on the linux kernel
> developers' schedule".
> 
> virtually all of the comments in the allwinner source code are in
> chinese, russell.

This is a bullshit excuse they do speak english

and I do work in Asia for lot of years and company like Allwinner do speak english
as we did work with them

And the ONLY point is that the culture difference that'a all

Best Regards,
J.