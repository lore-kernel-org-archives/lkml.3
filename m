Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbaFPOhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:37:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46081 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbaFPOhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:37:34 -0400
Date: Mon, 16 Jun 2014 09:36:44 -0500
From: Felipe Balbi <balbi@ti.com>
To: Paul Walmsley <paul@pwsan.com>
CC: Felipe Balbi <balbi@ti.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sathya Prakash M R <sathyap@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Darren Etheridge <detheridge@ti.com>
Subject: Re: [RESEND PATCH 1/2] ARM: AM43xx: hwmod: add DSS hwmod data
Message-ID: <20140616143644.GA16850@saruman.home>
Reply-To: <balbi@ti.com>
References: <1402676147-3711-1-git-send-email-balbi@ti.com>
 <1402676147-3711-2-git-send-email-balbi@ti.com>
 <20140613162323.GH8319@saruman.home>
 <alpine.DEB.2.02.1406131910060.340@utopia.booyaka.com>
 <20140613231019.GA24121@saruman.home>
 <alpine.DEB.2.02.1406140127020.20370@utopia.booyaka.com>
 <20140614045603.GA28775@saruman.home>
 <alpine.DEB.2.02.1406150257380.659@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BwCQnh7xodEAoBMC"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1406150257380.659@utopia.booyaka.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--BwCQnh7xodEAoBMC
Content-Type: multipart/mixed; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Jun 15, 2014 at 03:29:40AM +0000, Paul Walmsley wrote:
> Hi,
>=20
> On Fri, 13 Jun 2014, Felipe Balbi wrote:
>=20
> > On Sat, Jun 14, 2014 at 02:57:32AM +0000, Paul Walmsley wrote:
> > > > > > > From: Sathya Prakash M R <sathyap@ti.com>
> > > > > > >=20
> > > > > > > Add DSS hwmod data for AM43xx.
> > > > > > >=20
> > > > > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > > > > Acked-by: Rajendra Nayak <rnayak@ti.com>
> > > > > > > Signed-off-by: Sathya Prakash M R <sathyap@ti.com>
> > > > > > > Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> > > > > > > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > > > > > > ---
> > > > > > >=20
> > > > > > > Note that this patch was originally send on May 9th [1], chan=
ges were requested
> > > > > > > and a new version was sent on May 19th [2], then on May 27th =
[3] Tomi pinged
> > > > > > > maintainer again and go no response.
> > > > > > >=20
> > > > > > > Without this patch, we cannot get display working on any AM43=
7x devices.
> > > > > > >=20
> > > > > > > [1] http://marc.info/?l=3Dlinux-arm-kernel&m=3D13996367792522=
7&w=3D2
> > > > > > > [2] http://marc.info/?l=3Dlinux-arm-kernel&m=3D14004979942551=
2&w=3D2
> > > > > > > [3] http://marc.info/?l=3Dlinux-arm-kernel&m=3D14011723282675=
4&w=3D2
> > > > > > >=20
> > > > > > >  arch/arm/mach-omap2/omap_hwmod_43xx_data.c | 98 ++++++++++++=
++++++++++++++++++
> > > > > > >  arch/arm/mach-omap2/prcm43xx.h             |  1 +
> > > > > > >  2 files changed, 99 insertions(+)
> > > > >=20
> > > > > Sorry for the delay on this.  Have been corresponding with TI man=
agement=20
> > > > > to figure out what to do about patches for AM43xx.  I don't have =
boards or=20
> > > > > public documentation for these devices, so it's impossible for me=
 to=20
> > > > > meaningfully review the patches.  Looks like boards and/or public=
 docs=20
> > > > > won't be coming any time soon.
> > > > >=20
> > > > > So for my part, here's what I'll need to merge any hwmod or PRCM =
patches=20
> > > > > that involve AM437x:
> > > > >=20
> > > > > 1. A Reviewed-by: from one of the following folks (which should c=
ome from
> > > > > a different person than who is submitting the patches):
> > > > >=20
> > > > > Roger Quadros
> > > > > Nishanth Menon
> > > > > Rajendra Nayak
> > > > > Kevin Hilman
> > > > > Tony Lindgren
> > > > >=20
> > > > > 2. A Tested-by: from one of the following folks (who can be the s=
ame as=20
> > > > > the person who is the same as the person who is submitting the pa=
tches):
> > > > >=20
> > > > > Nishanth Menon
> > > > > Rajendra Nayak
> > > > > Kevin Hilman=20
> > > > > Tony Lindgren
> > > >=20
> > > > What you're saying here is that it's pointless for anybody else in =
TI to
> > > > review and/or test patches because you will only accept such tags f=
rom
> > > > this list of 4 ~ 5 people.
> > >=20
> > > That might be how you interpreted the E-mail.  But that's not what wa=
s=20
> > > written.
> >=20
> > of course it was. Read what you wrote:
> >=20
> > "here's what I'll need to *merge* any hwmod or PRCM patches that involve
> > AM437x".
> >=20
> > That basically puts down the requirements to getting any patches
> > accepted and those requirements are the blessings of a handful.
> >=20
> > > For the record, I'm pleased to accept Reviewed-by:s and Tested-by:s f=
rom=20
> > > anyone.  But, like most maintainers, there are some folks who I think=
 do a=20
> > > better job of reviewing and testing hwmod and PRCM patches than other=
s.
> > >=20
> > > The people listed above are a first cut at that list.  I'm certainly
> > > happy to consider adding others, but the reviewers need:
> > >=20
> > > 1. to have experience with those parts of the kernel;
> > >=20
> > > 2. to have access to the canonical documentation for AM43xx to review
> > > against; and
> >=20
> > anybody in ti.com have access to those.
> >=20
> > > 3. to have some kind of track record doing in-depth reviews of patches
> > > for that subsystem, or writing clean code for that subsystem.
> > >=20
> > >=20
> > > Similarly, for testers, the folks listed above are people who:
> > >=20
> > > 1. could actually have AM43xx boards; and
> >=20
> > well, quite a few have rather easy access to multiple (3, to be exact)
> > different am437x platforms.
> >=20
> > > 2. who have a history of testing patches against mainline kernels in=
=20
> > > public forums, rather than testing against vendor kernels; and
> >=20
> > $subject and patch two have both been tested on top of linux next from
> > june 10th. Is that bleeding edge enough for you ? Moreover, *only* these
> > two patches were applied on top of Stephen's linux-next.
> >=20
> > > 3. who I think would be mortally embarrassed if a patch was broken=20
> > > that they had a Tested-by: for.
> >=20
> > right, and when those guys try to get bugs fixed, we spend half a year
> > discussing pointless might-happen-when-the-sun-dies problems with other
> > drivers even when... aaaah what the heck, you'll just say I'm mixing
> > threads again...
> >=20
> > The point is that it has been this back and forth for quite a while now,
> > in countless occasions we have missed merge windows because this or that
> > maintainer just stops responding and *nobody* else has balls to pick the
> > patch up.
> >=20
> > Weeks later social network posts start to arise blaming TI for not
> > sending patches upstream.
> >=20
> > > (N.B. In the case of anything involving DSS, such as this patch, I'd =
be=20
> > > happy to accept Tested-by:s from Archit or Tomi.)
> > >=20
> > > If you have other people that you think I'm missing from the above tw=
o=20
> > > lists, who meet those requirements, please suggest some names!
> >=20
> > the point is about not having a list. Sure, you need to know some folks
> > who you can trust, but sometimes, when it's clear that the patch doesn't
> > break anything, follows standard code practices, have passed through
> > more than one hand and soaked in the mailing list for months, it's time
> > to give up and just let the patch sit in linux-next for a while. You can
> > always revert if someone else starts to scream.
> >=20
> > I'm *not* saying that you should blindly accept anything, but not
> > accepting patches without a reason isn't fair.
> >=20
> > > > Quite frankly, it's very upsetting to see an affirmation that all t=
he
> > > > work that I (personally) and many others do is seen as "pointless" =
=66rom
> > > > your side *unless* it gets the blessing from the few folks listed a=
bove.
> > >=20
> > > I'd be curious to know how many of the people listed in the Signed-of=
f-by:=20
> > > for these patches have double-checked the data against the TRM (or=20
> >=20
> > I know I've done it. Have latest am437x Datasheed, TRM and board
> > schematics open for quite a while now as I've been hacking this am437x
> > StarterKit.
> >=20
> > Also, the thing is functional. Xorg + i3 runs just fine without any
> > glitches or bogus colors, or any sort of warnings, errors, anything at
> > all.
> >=20
> > > whatever documentation is canonical for this chip).  And have thought=
=20
> > > through whether the data actually makes sense with regards to the SoC=
=20
> > > integration.  I consider those to be the prerequisites for reviewing =
hwmod=20
> >=20
> > how else would we get the freaking thing to enable clocks ? Or are you
> > forgetting that long ago the entire OMAP architecture was made tightly
> > coupled with runtime PM and HWMOD; and are you also forgetting that no
> > driver is now allowed to call clk_get() directly without hurting
> > somebody's feelings ?
> >=20
> > With these details in mind, there's no SoC who depends on mach-omap2
> > that can have any chance of *working* without hwmod data.
> >=20
> > > device data patches.  That's what I generally do myself, and that's w=
hat I=20
> > > expect from trusted reviewers.
> >=20
> > alright, so do you see any problems with the patch ? Do you think the
> > data isn't necessary ? Instead of just being silent for months, why
> > don't you just drop a line ? Reply to the f-ing thread ? How can we make
> > any progress if you don't ? Is this what we have to go now ? Send a
> > patch and hopefully, some day, it will make its way to mainline ?
> >=20
> > > > This just makes it ever more difficult for anything, which is clear=
ly
> > > > *BROKEN* to be fixed upstream and will just contribute to people
> > > > vanishing from mainline development.
> > >=20
> > > Sounds like you might be mixing mailing list threads. =20
> > >=20
> > > The description for these patches states:
> > >=20
> > > "Add DSS hwmod data for AM43xx"
> > >=20
> > > Unless I'm missing something, these patches add a feature.  They are =
not=20
> > > fixing something that is broken.
> >=20
> > without DSS hwmod data, how can display work ? So it _is_ broken indeed.
> > The same DSS code is functional in many other SoCs, but it's *broken* in
> > am437x because $subject has been pending without *any* reply since
> > May 19th.
> >=20
> > > > The very fact that you will only accept patches blessed by the gang=
-of-4
> > > > goes against the very foundations of open source development. Just
> > > > because you don't have access to documentation - and granted, that
> > > > _does_ make things a lot more difficult - does not mean you have to
> > > > consider an entire company as a non-trust worthy organization. Spec=
ially
> > > > when there are so many here who have been doing mainline developmen=
t for
> > > > quite some time.
> > >=20
> > > As stated, I'm happy to consider adding more folks to the list, but t=
hey=20
> > > need to have a track record of doing good work in that area, or doing=
=20
> > > in-depth reviews.  If they don't have one yet, well, there's no bette=
r=20
> > > time to start than the present.
> > >=20
> > > I'm also happy to do the reviews and a basic test myself, if I have=
=20
> > > documentation and a board.
> > >=20
> > > > It doesn't take a brain surgeon to note how this won't scale and, i=
f you=20
> > > > continue to ignore patches during the entire development cycle and =
only=20
> > > > reply after it's too late for $this merge window, it won't help muc=
h.
> > >=20
> > > ...
> > >=20
> > > > Anyway, whatever... I just hope that if we go through *another* mer=
ge
> > > > window without $subject being merged
> > >=20
> > > What is this business about "*another* merge window" and "continue to=
=20
> > > ignore"?  Using the dates from your own E-mail message above, the ori=
ginal=20
> > > patches were sent May 9th.  This was the same day that v3.15-rc5 was=
=20
> > > released. According to your message, the revised patches were sent Ma=
y=20
> > > 19th - three days before v3.15-rc6.
> >=20
> > right, right.. I'm talking in general. This *could* have made it into
> > v3.16. There are also other patches which were missed. One of them since
> > january.
> >=20
> > > So by the time these patches were ready to go, we'd already reached t=
he=20
> > > cutoff point for getting anything merged into v3.16.
> >=20
> > not really. We had 3 more tags (3 more weeks) until v3.15 final was
> > tagged. Add to that the fact that the merge window is 2 weeks long, 4
> > weeks (leaving the last week as padding) seems like enough time.
> >=20
> > > I was rather hoping that I'd be able to review it against the AM43xx=
=20
> > > documentation in time, but that turned out not to be available.
> > >=20
> > > If all this has nothing to do with the $SUBJECT patches, and is about=
 the=20
> > > DSS clocking issue, and not these patches, that's fine; but please di=
rect=20
> > > your flames to that thread instead.
> > >=20
> > > > ps: $subject in particular, has been tested by 3 different people.
> > > > Actually 4, if you consider Darren Etheridge who used $subject to h=
elp
> > > > me get display working on AM437x SK.
> > >=20
> > > There are no Tested-by:s on this patch.  It seems likely to me that T=
omi=20
> > > has tested it against something close to mainline, just based on gene=
ral=20
> > > experience with his level of patch quality in the past, but in genera=
l, I=20
> > > have no way of knowing this.
> >=20
> > SoB usually means the patch was tested by that person. Or are you
> > implying that neither me nor Sathya (patch author!!) ever tested the
> > patch ? I can post a video on youtube if that makes you happy, but boy
> > do I want to avoid doing that...
> >=20
> > > So if folks actually tested it against mainline, please do send=20
> > > Tested-by:s, and note the mainline commit that it was tested on, alon=
g=20
> > > with other patches were needed for this patch to apply and/or work.  =
It's=20
> > > also helpful to include a serial console boot log to a Tested-by: mes=
sage. =20
> > > That adds confidence that the patches don't add extra warnings and th=
at=20
> > > the commit ID is what's expected.
> >=20
> > sure thing, but don't expect everybody to just figure out what's going
> > on inside your head. Silent gets us nowhere.
> >=20
> > > For the specific case of this patch, since it's already been reviewed=
 by=20
> > > Rajendra, once there are good Tested-by:s sent to the list, I'd say i=
t's=20
> > > ready to merge.
> >=20
> > good Tested-by:s ?
> >=20
> > nice
>=20
> Felipe, here's what I need:
>=20
> For boards that I don't have access to, that I don't have=20
> documentation for, such as the AM43xx and DRA7xx), for me to merge or ack=
=20
> SoC infrastructure or PM-related patches, I want to have:
>=20
> 1. a Reviewed-by: from people who:
>=20
> a. I think know something about SoC integration or PM in general, and=20
> about OMAP-style integration specifically; and
>=20
> b. who have a track record of doing strong and detailed reviews of that=
=20
> code, or who have contributed significantly to that code in the past.
>=20
> My initial list of those reviewers is listed above, and I am happy to=20
> consider extending it or modifying that list.
>=20
>=20
> 2. confidence that the patch or series has been tested against a mainline=
=20
> commit and isn't obviously breaking other things, like PM, and confidence=
=20
> that it's not adding new runtime warnings.
>=20
> I've listed an initial set of people above who I feel have proven track=
=20
> records in testing who I'm happy to accept Tested-by:s without further=20
> explanation.  I'm sure I've missed some folks and if anyone who should be=
=20
> on that list is offended that I didn't mention them, please accept my=20
> apologies.  For other folks, like yourself, who aren't on that list (yet)=
,=20
> please just specifically state:
>=20
> a. what mainline commit they've tested the patch against,

As I said, linux-next from June 10th.

commit 27a4e439fe5cd92b70137ae237c7aa6888c07b5a
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Tue Jun 10 16:37:52 2014 +1000

    Add linux-next specific files for 20140610
   =20
    Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

> b. what other prerequisite patches were needed for the patch to apply,

only these two patches I sent here.

> c. and a cut-and-paste of the serial console boot log from the boot=20
> portion of the test.

attached minicom.cap. The "dirty" part is just another set of minor
changes (see below) I'm testing to, hopefully, include in the final DTS
too; and the WARNING you see, was caused by RMK's L2 rework but IIRC
Sekhar already had a fix for it, not sure if it has already reached
next.

diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
index 49fa596..e3830d4 100644
--- a/arch/arm/boot/dts/am4372.dtsi
+++ b/arch/arm/boot/dts/am4372.dtsi
@@ -270,7 +270,7 @@
 			ti,hwmods =3D "counter_32k";
 		};
=20
-		rtc@44e3e000 {
+		rtc: rtc@44e3e000 {
 			compatible =3D "ti,am4372-rtc","ti,da830-rtc";
 			reg =3D <0x44e3e000 0x1000>;
 			interrupts =3D <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH
@@ -279,7 +279,7 @@
 			status =3D "disabled";
 		};
=20
-		wdt@44e35000 {
+		wdt: wdt@44e35000 {
 			compatible =3D "ti,am4372-wdt","ti,omap3-wdt";
 			reg =3D <0x44e35000 0x1000>;
 			interrupts =3D <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm/boot/dts/am437x-sk-evm.dts b/arch/arm/boot/dts/am437x=
-sk-evm.dts
index 51ffab1..59b620b 100644
--- a/arch/arm/boot/dts/am437x-sk-evm.dts
+++ b/arch/arm/boot/dts/am437x-sk-evm.dts
@@ -374,6 +374,16 @@
 		DRVDD-supply =3D <&v33_fixed>;
 		DVDD-supply =3D <&v18_fixed>;
 	};
+
+	lis331dlh@18 {
+		compatible =3D "st,lis331dlh";
+		reg =3D <0x18>;
+		status =3D "okay";
+
+		Vdd-supply =3D <&v33_fixed>;
+		Vdd_IO-supply =3D <&v33_fixed>;
+		interrupts-extended =3D <&gpio1 6 0>, <&gpio2 1 0>;
+	};
 };
=20
 &epwmss0 {
@@ -537,3 +547,23 @@
 		};
 	};
 };
+
+&sham {
+	status =3D "okay";
+};
+
+&aes {
+	status =3D "okay";
+};
+
+&des {
+	status =3D "okay";
+};
+
+&rtc {
+	status =3D "okay";
+};
+
+&wdt {
+	status =3D "okay";
+};


--=20
balbi

--LQksG6bCIzRHxTLp
Content-Type: application/vnd.tcpdump.pcap
Content-Disposition: attachment; filename="minicom.cap"
Content-Transfer-Encoding: quoted-printable

boot=0Ammc0 is current device=0ASD/MMC found on device 0=0Areading uEnv.txt=
=0A** Unable to read file uEnv.txt **=0A4704744 bytes read in 374 ms (12 Mi=
B/s)=0A36130 bytes read in 416 ms (84 KiB/s)=0ABooting from mmc0 ...=0AKern=
el image @ 0x82000000 [ 0x000000 - 0x47c9e8 ]=0A## Flattened Device Tree bl=
ob at 88000000=0A   Booting using the fdt blob at 0x88000000=0A   Loading D=
evice Tree to 8fff4000, end 8ffffd21 ... OK=0A=0AStarting kernel ...=0A=0A[=
    0.000000] Booting Linux on physical CPU 0x0=0A[    0.000000] Initializi=
ng cgroup subsys cpuset=0A[    0.000000] Initializing cgroup subsys cpu=0A[=
    0.000000] Initializing cgroup subsys cpuacct=0A[    0.000000] Linux ver=
sion 3.15.0-next-20140610-00002-g3853d91-dirty (balbi@saruman) (gcc version=
 4.8.2 20130902 (prerelease) (crosstool-NG linaro-1.13.1-4.8-2013.09 - Lina=
ro GCC 2013.09) ) #199 SMP Fri Jun 13 18:21:45 CDT 2014=0A[    0.000000] CP=
U: ARMv7 Processor [412fc09a] revision 10 (ARMv7), cr=3D10c5387d=0A[    0.0=
00000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction c=
ache=0A[    0.000000] Machine model: TI AM437x SK EVM=0A[    0.000000] cma:=
 CMA: reserved 16 MiB at ae800000=0A[    0.000000] Memory policy: Data cach=
e writeback=0A[    0.000000] CPU: All CPU(s) started in SVC mode.=0A[    0.=
000000] AM437x ES1.1 (sgx neon )=0A[    0.000000] L2C: platform modifies au=
x control register: 0x0e030000 -> 0x3e430000=0A[    0.000000] L2C: DT/platf=
orm modifies aux control register: 0x0e030000 -> 0x3e430000=0A[    0.000000=
] L2C-310 enabling early BRESP for Cortex-A9=0A[    0.000000] L2C-310 ID pr=
efetch enabled, offset 1 lines=0A[    0.000000] ------------[ cut here ]---=
---------=0A[    0.000000] WARNING: CPU: 0 PID: 0 at arch/arm/mach-omap2/om=
ap4-common.c:192 omap4_l2c310_write_sec+0x74/0xa8()=0A[    0.000000] OMAP L=
2C310: ignoring write to reg 0xf80=0A[    0.000000] Modules linked in:=0A[ =
   0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.15.0-next-20140610-0=
0002-g3853d91-dirty #199=0A[    0.000000] [<c0015330>] (unwind_backtrace) f=
rom [<c0011f6c>] (show_stack+0x10/0x14)=0A[    0.000000] [<c0011f6c>] (show=
_stack) from [<c05caf88>] (dump_stack+0x84/0x9c)=0A[    0.000000] [<c05caf8=
8>] (dump_stack) from [<c0041d6c>] (warn_slowpath_common+0x6c/0x90)=0A[    =
0.000000] [<c0041d6c>] (warn_slowpath_common) from [<c0041dc0>] (warn_slowp=
ath_fmt+0x30/0x40)=0A[    0.000000] [<c0041dc0>] (warn_slowpath_fmt) from [=
<c002b0cc>] (omap4_l2c310_write_sec+0x74/0xa8)=0A[    0.000000] [<c002b0cc>=
] (omap4_l2c310_write_sec) from [<c0864e50>] (l2c310_enable+0x12c/0x1fc)=0A=
[    0.000000] [<c0864e50>] (l2c310_enable) from [<c0864c9c>] (__l2c_init+0=
x160/0x1e8)=0A[    0.000000] [<c0864c9c>] (__l2c_init) from [<c0865370>] (l=
2x0_of_init+0x140/0x164)=0A[    0.000000] [<c0865370>] (l2x0_of_init) from =
[<c086b4f8>] (omap_l2_cache_init+0x60/0x98)=0A[    0.000000] [<c086b4f8>] (=
omap_l2_cache_init) from [<c0866544>] (am43xx_init_early+0x58/0x80)=0A[    =
0.000000] [<c0866544>] (am43xx_init_early) from [<c0861204>] (setup_arch+0x=
89c/0x980)=0A[    0.000000] [<c0861204>] (setup_arch) from [<c085d888>] (st=
art_kernel+0x80/0x3a0)=0A[    0.000000] [<c085d888>] (start_kernel) from [<=
80008074>] (0x80008074)=0A[    0.000000] ---[ end trace 3406ff24bd97382e ]-=
--=0A[    0.000000] L2C-310 dynamic clock gating disabled, standby mode dis=
abled=0A[    0.000000] L2C-310 cache controller enabled, 16 ways, 256 kB=0A=
[    0.000000] L2C-310: CACHE_ID 0x410000c9, AUX_CTRL 0x7e430000=0A[    0.0=
00000] PERCPU: Embedded 9 pages/cpu @edfb6000 s14464 r8192 d14208 u36864=0A=
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 260624=0A[    0.000000] Kernel command line: console=3DttyO0,11520=
0n8 root=3D/dev/mmcblk0p2 rw rootfstype=3Dext4 rootwait=0A[    0.000000] PI=
D hash table entries: 4096 (order: 2, 16384 bytes)=0A[    0.000000] Dentry =
cache hash table entries: 131072 (order: 7, 524288 bytes)=0A[    0.000000] =
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)=0A[    0.000=
000] Memory: 1004996K/1048576K available (6144K kernel code, 705K rwdata, 2=
384K rodata, 410K init, 8229K bss, 43580K reserved, 270336K highmem)=0A[   =
 0.000000] Virtual kernel memory layout:=0A[    0.000000]     vector  : 0xf=
fff0000 - 0xffff1000   (   4 kB)=0A[    0.000000]     fixmap  : 0xffc00000 =
- 0xffe00000   (2048 kB)=0A[    0.000000]     vmalloc : 0xf0000000 - 0xff00=
0000   ( 240 MB)=0A[    0.000000]     lowmem  : 0xc0000000 - 0xef800000   (=
 760 MB)=0A[    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)=
=0A[    0.000000]     modules : 0xbf000000 - 0xbfe00000   (  14 MB)=0A[    =
0.000000]       .text : 0xc0008000 - 0xc085c60c   (8530 kB)=0A[    0.000000=
]       .init : 0xc085d000 - 0xc08c3880   ( 411 kB)=0A[    0.000000]       =
=2Edata : 0xc08c4000 - 0xc09745e8   ( 706 kB)=0A[    0.000000]        .bss =
: 0xc09745e8 - 0xc117dd10   (8230 kB)=0A[    0.000000] Hierarchical RCU imp=
lementation.=0A[    0.000000] 	RCU restricting CPUs from NR_CPUS=3D2 to nr_=
cpu_ids=3D1.=0A[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=
=3D16, nr_cpu_ids=3D1=0A[    0.000000] NR_IRQS:16 nr_irqs:16 16=0A[    0.00=
0000] GIC CPU mask not found - kernel will fail to boot.=0A[    0.000000] G=
IC CPU mask not found - kernel will fail to boot.=0A[    0.000000] OMAP clo=
ckevent source: timer2 at 24000000 Hz=0A[    0.000010] sched_clock: 32 bits=
 at 24MHz, resolution 41ns, wraps every 178956969942ns=0A[    0.000061] OMA=
P clocksource: timer1 at 24000000 Hz=0A[    0.000662] Console: colour dummy=
 device 80x30=0A[    0.000700] Lock dependency validator: Copyright (c) 200=
6 Red Hat, Inc., Ingo Molnar=0A[    0.000712] ... MAX_LOCKDEP_SUBCLASSES:  =
8=0A[    0.000722] ... MAX_LOCK_DEPTH:          48=0A[    0.000732] ... MAX=
_LOCKDEP_KEYS:        8191=0A[    0.000742] ... CLASSHASH_SIZE:          40=
96=0A[    0.000751] ... MAX_LOCKDEP_ENTRIES:     32768=0A[    0.000760] ...=
 MAX_LOCKDEP_CHAINS:      65536=0A[    0.000769] ... CHAINHASH_SIZE:       =
   32768=0A[    0.000779]  memory used by lock dependency info: 5167 kB=0A[=
    0.000788]  per task-struct memory footprint: 1152 bytes=0A[    0.000831=
] Calibrating delay loop... 1993.93 BogoMIPS (lpj=3D9969664)=0A[    0.11921=
2] pid_max: default: 32768 minimum: 301=0A[    0.119544] Security Framework=
 initialized=0A[    0.119652] Mount-cache hash table entries: 2048 (order: =
1, 8192 bytes)=0A[    0.119670] Mountpoint-cache hash table entries: 2048 (=
order: 1, 8192 bytes)=0A[    0.122013] Initializing cgroup subsys devices=
=0A[    0.122134] Initializing cgroup subsys freezer=0A[    0.122204] Initi=
alizing cgroup subsys debug=0A[    0.122339] CPU: Testing write buffer cohe=
rency: ok=0A[    0.123357] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000=
=0A[    0.123469] Setting up static identity map for 0x805d6408 - 0x805d647=
8=0A[    0.126384] Brought up 1 CPUs=0A[    0.126406] SMP: Total of 1 proce=
ssors activated.=0A[    0.126421] CPU: All CPU(s) started in SVC mode.=0A[ =
   0.128799] devtmpfs: initialized=0A[    0.139641] VFP support v0.3: imple=
mentor 41 architecture 3 part 30 variant 9 rev 4=0A[    0.172948] omap_hwmo=
d: tptc0 using broken dt data from edma=0A[    0.173248] omap_hwmod: tptc1 =
using broken dt data from edma=0A[    0.173528] omap_hwmod: tptc2 using bro=
ken dt data from edma=0A[    0.238125] omap_hwmod: dss_dispc: cannot be ena=
bled for reset (3)=0A[    0.241437] omap_hwmod: dss_rfbi: cannot be enabled=
 for reset (3)=0A[    0.243370] pinctrl core: initialized pinctrl subsystem=
=0A[    0.245448] regulator-dummy: no parameters=0A[    0.267068] NET: Regi=
stered protocol family 16=0A[    0.273919] DMA: preallocated 256 KiB pool f=
or atomic coherent allocations=0A[    0.275817] cpuidle: using governor lad=
der=0A[    0.275867] cpuidle: using governor menu=0A[    0.290063] platform=
 49000000.edma: alias fck already exists=0A[    0.290153] platform 49000000=
=2Eedma: alias fck already exists=0A[    0.290174] platform 49000000.edma: =
alias fck already exists=0A[    0.291521] platform 44e3e000.rtc: Cannot loo=
kup hwmod 'rtc'=0A[    0.293921] OMAP GPIO hardware version 0.1=0A[    0.29=
9916] platform 53701000.des: Cannot lookup hwmod 'des'=0A[    0.305920] No =
ATAGs?=0A[    0.306004] hw-breakpoint: found 5 (+1 reserved) breakpoint and=
 1 watchpoint registers.=0A[    0.306042] hw-breakpoint: maximum watchpoint=
 size is 4 bytes.=0A[    0.337808] edma-dma-engine edma-dma-engine.0: TI ED=
MA DMA engine driver=0A[    0.338890] vmmcsd_fixed: 3300 mV =0A[    0.33962=
0] v33_fixed: 3300 mV =0A[    0.340182] v18_fixed: 1800 mV =0A[    0.342900=
] SCSI subsystem initialized=0A[    0.343492] usbcore: registered new inter=
face driver usbfs=0A[    0.343633] usbcore: registered new interface driver=
 hub=0A[    0.344194] usbcore: registered new device driver usb=0A[    0.34=
5009] omap_i2c 44e0b000.i2c: could not find pctldev for node /pinmux@44e108=
00/i2c0_pins, deferring probe=0A[    0.345054] platform 44e0b000.i2c: Drive=
r omap_i2c requests probe deferral=0A[    0.345111] omap_i2c 4802a000.i2c: =
could not find pctldev for node /pinmux@44e10800/i2c1_pins, deferring probe=
=0A[    0.345135] platform 4802a000.i2c: Driver omap_i2c requests probe def=
erral=0A[    0.346077] Advanced Linux Sound Architecture Driver Initialized=
=2E=0A[    0.348748] Switched to clocksource timer1=0A[    0.445431] NET: R=
egistered protocol family 2=0A[    0.447021] TCP established hash table ent=
ries: 8192 (order: 3, 32768 bytes)=0A[    0.447210] TCP bind hash table ent=
ries: 8192 (order: 6, 294912 bytes)=0A[    0.449032] TCP: Hash tables confi=
gured (established 8192 bind 8192)=0A[    0.449373] TCP: reno registered=0A=
[    0.449436] UDP hash table entries: 512 (order: 3, 40960 bytes)=0A[    0=
=2E449694] UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)=0A[    =
0.450771] NET: Registered protocol family 1=0A[    0.452097] RPC: Registere=
d named UNIX socket transport module.=0A[    0.452144] RPC: Registered udp =
transport module.=0A[    0.452157] RPC: Registered tcp transport module.=0A=
[    0.452170] RPC: Registered tcp NFSv4.1 backchannel transport module.=0A=
[    0.455716] futex hash table entries: 256 (order: 2, 16384 bytes)=0A[   =
 0.459436] VFS: Disk quotas dquot_6.5.2=0A[    0.459549] Dquot-cache hash t=
able entries: 1024 (order 0, 4096 bytes)=0A[    0.461342] NFS: Registering =
the id_resolver key type=0A[    0.461648] Key type id_resolver registered=
=0A[    0.461683] Key type id_legacy registered=0A[    0.461834] jffs2: ver=
sion 2.2. (NAND) (SUMMARY)  =C2=A9 2001-2006 Red Hat, Inc.=0A[    0.462246]=
 msgmni has been set to 1466=0A[    0.465150] bounce: pool size: 64 pages=
=0A[    0.465290] io scheduler noop registered=0A[    0.465316] io schedule=
r deadline registered=0A[    0.465377] io scheduler cfq registered (default=
)=0A[    0.469928] pinctrl-single 44e10800.pinmux: 199 pins at pa f9e10800 =
size 796=0A[    0.474284] backlight supply power not found, using dummy reg=
ulator=0A[    0.477199] OMAP DSS rev 2.0=0A[    0.486288] Console: switchin=
g to colour frame buffer device 60x34=0A[    0.492174] omapfb omapfb: using=
 display 'lcd' mode 480x272=0A[    0.493818] Serial: 8250/16550 driver, 4 p=
orts, IRQ sharing enabled=0A[    0.499566] omap_uart 44e09000.serial: no wa=
keirq for uart0=0A[    0.499622] omap_uart 44e09000.serial: No clock speed =
specified: using default: 48000000=0A[    0.499978] 44e09000.serial: ttyO0 =
at MMIO 0x44e09000 (irq =3D 104, base_baud =3D 3000000) is a OMAP UART0=0A[=
    1.473408] console [ttyO0] enabled=0A[    1.497024] brd: module loaded=
=0A[    1.512538] loop: module loaded=0A[    1.519207] ti-qspi 47900000.qsp=
i: memory mapped resource not required=0A[    1.640287] usbcore: registered=
 new interface driver asix=0A[    1.646063] usbcore: registered new interfa=
ce driver ax88179_178a=0A[    1.652677] usbcore: registered new interface d=
river cdc_ether=0A[    1.659010] usbcore: registered new interface driver s=
msc95xx=0A[    1.665106] usbcore: registered new interface driver net1080=
=0A[    1.671185] usbcore: registered new interface driver cdc_subset=0A[  =
  1.677462] usbcore: registered new interface driver zaurus=0A[    1.683516=
] usbcore: registered new interface driver cdc_ncm=0A[    1.691625] usbcore=
: registered new interface driver cdc_wdm=0A[    1.697715] usbcore: registe=
red new interface driver usb-storage=0A[    1.704327] usbcore: registered n=
ew interface driver usbtest=0A[    1.713024] mousedev: PS/2 mouse device co=
mmon for all mice=0A[    1.721684] omap_rtc 44e3e000.rtc: _od_fail_runtime_=
resume: FIXME: missing hwmod/omap_dev info=0A[    1.732097] omap_rtc 44e3e0=
00.rtc: rtc core: registered 44e3e000.rtc as rtc0=0A[    1.739720] 44e3e000=
=2Ertc: already running=0A[    1.744518] i2c /dev entries driver=0A[    1.7=
48244] Driver for 1-wire Dallas network protocol.=0A[    1.757949] omap_wdt=
: OMAP Watchdog Timer Rev 0x01: initial timeout 60 sec=0A[    1.811582] led=
trig-cpu: registered to indicate activity on CPUs=0A[    1.818307] usbcore:=
 registered new interface driver usbhid=0A[    1.824300] usbhid: USB HID co=
re driver=0A[    1.839419] davinci_evm sound: ASoC: CODEC (null) not regist=
ered=0A[    1.846018] davinci_evm sound: snd_soc_register_card failed (-517=
)=0A[    1.852648] platform sound: Driver davinci_evm requests probe deferr=
al=0A[    1.860215] oprofile: no performance counters=0A[    1.865645] opro=
file: using timer interrupt.=0A[    1.870780] TCP: cubic registered=0A[    =
1.874294] Initializing XFRM netlink socket=0A[    1.879092] NET: Registered=
 protocol family 17=0A[    1.883839] NET: Registered protocol family 15=0A[=
    1.888910] Key type dns_resolver registered=0A[    1.893622] omap_voltag=
e_late_init: Voltage driver support not added=0A[    1.900378] sr_dev_init:=
 No voltage domain specified for smartreflex0. Cannot initialize=0A[    1.9=
09088] sr_dev_init: No voltage domain specified for smartreflex1. Cannot in=
itialize=0A[    1.918451] ThumbEE CPU extension supported.=0A[    1.923035]=
 Registering SWP/SWPB emulation handler=0A[    1.928052] SmartReflex Class3=
 initialized=0A[    1.946892] omap_i2c 44e0b000.i2c: bus 0 rev0.12 at 100 k=
Hz=0A[    1.977363] input: EP0820M09 as /devices/44000000.ocp/4802a000.i2c/=
i2c-1/1-0038/input/input0=0A[    1.993855] omap_i2c 4802a000.i2c: bus 1 rev=
0.12 at 100 kHz=0A[    2.005029] davinci_evm sound: tlv320aic3x-hifi <-> 48=
03c000.mcasp mapping ok=0A[    2.048025] mmc0: host does not support readin=
g read-only switch. assuming write-enable.=0A[    2.059643] mmc0: new high =
speed SDHC card at address aaaa=0A[    2.067816] mmcblk0: mmc0:aaaa SU32G 2=
9.7 GiB =0A[    2.077953]  mmcblk0: p1 p2=0A[    2.088791] davinci_mdio 4a1=
01000.mdio: davinci mdio revision 1.6=0A[    2.095223] davinci_mdio 4a10100=
0.mdio: detected phy mask ffffffcf=0A[    2.104886] libphy: 4a101000.mdio: =
probed=0A[    2.109281] davinci_mdio 4a101000.mdio: phy[4]: device 4a101000=
=2Emdio:04, driver unknown=0A[    2.117681] davinci_mdio 4a101000.mdio: phy=
[5]: device 4a101000.mdio:05, driver unknown=0A[    2.127052] cpsw 4a100000=
=2Eethernet: Detected MACID =3D 34:b1:f7:31:36:c8=0A[    2.135879] cpsw 4a1=
00000.ethernet: cpsw: Detected MACID =3D 34:b1:f7:31:36:ca=0A[    2.144945]=
 omap_rtc 44e3e000.rtc: setting system clock to 2000-01-01 00:00:00 UTC (94=
6684800)=0A[    2.154063] sr_init: No PMIC hook to init smartreflex=0A[    =
2.159621] sr_init: platform driver register failed for SR=0A[    2.179566] =
v18_fixed: disabling=0A[    2.183056] v33_fixed: disabling=0A[    2.186646]=
 ALSA device list:=0A[    2.189862]   #0: AM437x-SK-EVM=0A[    2.501635] EX=
T4-fs (mmcblk0p2): warning: mounting fs with errors, running e2fsck is reco=
mmended=0A[    2.514220] EXT4-fs (mmcblk0p2): recovery complete=0A[    2.52=
2421] EXT4-fs (mmcblk0p2): mounted filesystem with ordered data mode. Opts:=
 (null)=0A[    2.531154] VFS: Mounted root (ext4 filesystem) on device 179:=
2.=0A[    2.548471] devtmpfs: mounted=0A[    2.552139] Freeing unused kerne=
l memory: 408K (c085d000 - c08c3000)=0A[    2.925920] systemd[1]: systemd 2=
04 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +L=
IBCRYPTSETUP +GCRYPT +ACL +XZ)=0A=0AWelcome to Debian GNU/Linux jessie/sid!=
=0A=0A[    2.976239] systemd[1]: Failed to insert module 'autofs4'=0A[    2=
=2E982449] systemd[1]: Failed to insert module 'ipv6'=0A[    2.990298] syst=
emd[1]: Set hostname to <saruman>.=0A[    3.025576] random: systemd urandom=
 read with 44 bits of entropy available=0A[    3.564380] systemd[1]: Cannot=
 add dependency job for unit display-manager.service, ignoring: Unit displa=
y-manager.service failed to load: No such file or directory. See system log=
s and 'systemctl status display-manager.service' for details.=0A[    3.5888=
76] systemd[1]: Starting Forward Password Requests to Wall Directory Watch.=
=0A[    3.598976] systemd[1]: Started Forward Password Requests to Wall Dir=
ectory Watch.=0A[    3.607040] systemd[1]: Expecting device dev-ttyO0.devic=
e...=0A         Expecting device dev-ttyO0.device...=0A[    3.628947] syste=
md[1]: Starting Remote File Systems (Pre).=0A[  OK  ] Reached target Remote=
 File Systems (Pre).=0A[    3.648874] systemd[1]: Reached target Remote Fil=
e Systems (Pre).=0A[    3.655403] systemd[1]: Starting Syslog Socket.=0A[  =
OK  ] Listening on Syslog Socket.=0A[    3.678890] systemd[1]: Listening on=
 Syslog Socket.=0A[    3.684138] systemd[1]: Starting /dev/initctl Compatib=
ility Named Pipe.=0A[  OK  ] Listening on /dev/initctl Compatibility Named =
Pipe.=0A[    3.708884] systemd[1]: Listening on /dev/initctl Compatibility =
Named Pipe.=0A[    3.716293] systemd[1]: Starting Delayed Shutdown Socket.=
=0A[  OK  ] Listening on Delayed Shutdown Socket.=0A[    3.738880] systemd[=
1]: Listening on Delayed Shutdown Socket.=0A[    3.745028] systemd[1]: Star=
ting Encrypted Volumes.=0A[  OK  ] Reached target Encrypted Volumes.=0A[   =
 3.768873] systemd[1]: Reached target Encrypted Volumes.=0A[    3.774715] s=
ystemd[1]: Starting Dispatch Password Requests to Console Directory Watch.=
=0A[    3.783793] systemd[1]: Started Dispatch Password Requests to Console=
 Directory Watch.=0A[    3.792338] systemd[1]: Starting Paths.=0A[  OK  ] R=
eached target Paths.=0A[    3.808876] systemd[1]: Reached target Paths.=0A[=
    3.813942] systemd[1]: Starting Arbitrary Executable File Formats File S=
ystem Automount Point.=0A[    3.823694] systemd[1]: Failed to open /dev/aut=
ofs: No such file or directory=0A[    3.831395] systemd[1]: Failed to initi=
alize automounter: No such file or directory=0A[FAILED] Failed to set up au=
tomount Arbitrary Executable File...utomount Point.=0ASee 'systemctl status=
 proc-sys-fs-binfmt_misc.automount' for details.=0A[    3.878869] systemd[1=
]: Failed to set up automount Arbitrary Executable File Formats File System=
 Automount Point.=0A[    3.889878] systemd[1]: Unit proc-sys-fs-binfmt_misc=
=2Eautomount entered failed state.=0A[    3.898856] systemd[1]: Starting ud=
ev Kernel Socket.=0A[  OK  ] Listening on udev Kernel Socket.=0A[    3.9188=
93] systemd[1]: Listening on udev Kernel Socket.=0A[    3.924986] systemd[1=
]: Starting udev Control Socket.=0A[  OK  ] Listening on udev Control Socke=
t.=0A[    3.948901] systemd[1]: Listening on udev Control Socket.=0A[    3.=
954731] systemd[1]: Starting Journal Socket.=0A[  OK  ] Listening on Journa=
l Socket.=0A[    3.978884] systemd[1]: Listening on Journal Socket.=0A[    =
3.984299] systemd[1]: Starting Syslog.=0A[  OK  ] Reached target Syslog.=0A=
[    4.008864] systemd[1]: Reached target Syslog.=0A[    4.013787] systemd[=
1]: Mounting Debug File System...=0A         Mounting Debug File System...=
=0A[    4.045489] systemd[1]: Starting udev Coldplug all Devices...=0A     =
    Starting udev Coldplug all Devices...=0A[    4.097346] systemd[1]: Star=
ting Apply Kernel Variables...=0A         Starting Apply Kernel Variables..=
=2E=0A[    4.129760] systemd[1]: Mounting POSIX Message Queue File System..=
=2E=0A         Mounting POSIX Message Queue File System...=0A[    4.192348]=
 systemd[1]: Started Set Up Additional Binary Formats.=0A[    4.209855] sys=
temd[1]: Starting Create static device nodes in /dev...=0A         Starting=
 Create static device nodes in /dev...=0A[    4.260739] systemd[1]: Startin=
g Load Kernel Modules...=0A         Starting Load Kernel Modules...=0A[    =
4.294565] systemd[1]: Mounted Huge Pages File System.=0A[    4.311861] syst=
emd[1]: Starting Journal Service...=0A         Starting Journal Service...=
=0A[  OK  ] Started Journal Service.=0A[    4.350526] systemd[1]: Started J=
ournal Service.=0A[    4.395191] systemd[1]: Starting Swap.=0A[  OK  ] Reac=
hed target Swap.=0A[    4.419161] systemd[1]: Reached target Swap.=0A[    4=
=2E423873] systemd[1]: Started File System Check on Root Device.=0A[  OK  ]=
 Mounted Debug File System.=0A[    4.479055] systemd[1]: Mounted Debug File=
 System.=0A[  OK  ] Started Apply Kernel Variables.=0A[    4.529061] system=
d[1]: Started Apply Kernel Variables.=0A[  OK  ] Mounted POSIX Message Queu=
e File System.=0A[    4.549194] systemd[1]: Mounted POSIX Message Queue Fil=
e System.=0A[  OK  ] Started Create static device nodes in /dev.=0A[    4.5=
99105] systemd[1]: Started Create static device nodes in /dev.=0A[    4.607=
092] systemd[1]: systemd-modules-load.service: main process exited, code=3D=
exited, status=3D1/FAILURE=0A[FAILED] Failed to start Load Kernel Modules.=
=0ASee 'systemctl status systemd-modules-load.service' for details.=0A[    =
4.689191] systemd[1]: Failed to start Load Kernel Modules.=0A[    4.695205]=
 systemd[1]: Unit systemd-modules-load.service entered failed state.=0A[   =
 4.709795] systemd[1]: Mounted FUSE Control File System.=0A[    4.715674] s=
ystemd[1]: Mounted Configuration File System.=0A[    4.740708] systemd[1]: =
Starting udev Kernel Device Manager...=0A         Starting udev Kernel Devi=
ce Manager...=0A[  OK  ] Started udev Kernel Device Manager.=0A[    4.88988=
4] systemd-udevd[879]: starting version 204=0A         Starting LSB: Set pr=
eliminary keymap...=0A         Starting Copy rules generated while the root=
 was ro...=0A[  OK  ] Started Copy rules generated while the root was ro.=
=0A[  OK  ] Started LSB: Set preliminary keymap.=0A         Starting Remoun=
t Root and Kernel File Systems...=0A[  OK  ] Started Remount Root and Kerne=
l File Systems.=0A[  OK  ] Reached target Local File Systems (Pre).=0A     =
    Mounting User Runtime Directory...=0A         Mounting Lock Directory..=
=2E=0A         Starting Load Random Seed...=0A[  OK  ] Mounted Lock Directo=
ry.=0A[  OK  ] Mounted User Runtime Directory.=0A[  OK  ] Reached target Lo=
cal File Systems.=0A         Starting Recreate Volatile Files and Directori=
es...=0A[  OK  ] Reached target Remote File Systems.=0A         Starting LS=
B: Set console font and keymap...=0A         Starting Trigger Flushing of J=
ournal to Persistent Storage...=0A[  OK  ] Started udev Coldplug all Device=
s.=0A[  OK  ] Started Load Random Seed.=0A[  OK  ] Started LSB: Set console=
 font and keymap.=0A         Starting LSB: Raise network interfaces....=0A[=
  OK  ] Started Recreate Volatile Files and Directories.=0A[  OK  ] Started=
 Trigger Flushing of Journal to Persistent Storage.=0A[  OK  ] Started LSB:=
 Raise network interfaces..=0A[  OK  ] Reached target System Initialization=
=2E=0A[  OK  ] Reached target Timers.=0A         Starting Restore Sound Car=
d State...=0A[  OK  ] Listening on Avahi mDNS/DNS-SD Stack Activation Socke=
t.=0A[  OK  ] Listening on D-Bus System Message Bus Socket.=0A[  OK  ] Reac=
hed target Sockets.=0A[    6.609012] random: nonblocking pool is initialize=
d=0A[  OK  ] Reached target Basic System.=0A         Starting LSB: keep mem=
ory of all UPnP devices that a...d themselves...=0A         Starting Avahi =
mDNS/DNS-SD Stack...=0A         Starting LSB: Create dynamic part of /etc/m=
otd...=0A         Starting LSB: Log file handling to be done during bootup.=
=2E..=0A         Starting LSB: Speech Dispatcher...=0A         Starting LSB=
: Start the GNUstep distributed object mapper...=0A         Starting Regula=
r background program processing daemon...=0A[  OK  ] Started Regular backgr=
ound program processing daemon.=0A         Starting Enable support for addi=
tional executable binary formats...=0A         Starting Run anacron jobs...=
=0A[  OK  ] Started Run anacron jobs.=0A         Starting Restore /etc/reso=
lv.conf if the system cras...s shut down....=0A         Starting Modem Mana=
ger...=0A         Starting Network Manager...=0A         Starting Login Ser=
vice...=0A         Starting Permit User Sessions...=0A         Starting Sys=
tem Logging Service...=0A         Starting D-Bus System Message Bus...=0A[ =
 OK  ] Started D-Bus System Message Bus.=0A         Starting LSB: SANE netw=
ork scanner server...=0A         Starting Accounts Service...=0A[  OK  ] Re=
ached target Network.=0A         Starting LSB: Start NTP daemon...=0A[  OK =
 ] Reached target Host and Network Name Lookups.=0A         Starting /etc/r=
c.local Compatibility...=0A[  OK  ] Started LSB: Create dynamic part of /et=
c/motd.=0A[  OK  ] Started Permit User Sessions.=0A[  OK  ] Started LSB: Sp=
eech Dispatcher.=0A[  OK  ] Started /etc/rc.local Compatibility.=0A        =
 Starting Getty on tty1...=0A[  OK  ] Started Getty on tty1.=0A[  OK  ] Sta=
rted Restore /etc/resolv.conf if the system crash...was shut down..=0A[  OK=
  ] Started LSB: Start the GNUstep distributed object mapper.=0A[  OK  ] St=
arted Enable support for additional executable binary formats.=0A[  OK  ] S=
tarted LSB: SANE network scanner server.=0A[  OK  ] Started System Logging =
Service.=0A[  OK  ] Started LSB: keep memory of all UPnP devices that an...=
ced themselves.=0A[  OK  ] Found device /dev/ttyO0.=0A         Starting Ser=
ial Getty on ttyO0...=0A[  OK  ] Started Serial Getty on ttyO0.=0A[  OK  ] =
Reached target Login Prompts.=0A[  OK  ] Started LSB: Start NTP daemon.=0A[=
  OK  ] Started Restore Sound Card State.=0A[  OK  ] Started Login Service.=
=0A[  OK  ] Started Avahi mDNS/DNS-SD Stack.=0A         Starting Authentica=
te and Authorize Users to Run Privileged Tasks...=0A[  OK  ] Started LSB: L=
og file handling to be done during bootup..=0A[  OK  ] Started Authenticate=
 and Authorize Users to Run Privileged Tasks.=0A[  OK  ] Started Accounts S=
ervice.=0A[    9.625352] lis3lv02d: 16 bits lis331dlh sensor found=0A[  OK =
 ] Started Network Manager.=0A         Starting LSB: Start the PulseAudio s=
ound server...=0A[  OK  ] Started Modem Manager.=0A[  OK  ] Started LSB: St=
art the PulseAudio sound server.=0A[  OK  ] Reached target Multi-User Syste=
m.=0A[  OK  ] Reached target Graphical Interface.=0A[   10.099366] omap-sha=
m 53100000.sham: hw accel on OMAP rev 0.0=0A[   10.146469] input: ST LIS3LV=
02DL Accelerometer as /devices/platform/lis3lv02d/input/input1=0A[   10.422=
960] omap-aes 53501000.aes: OMAP AES hw accel rev: 0.1=0A[   10.524310] sys=
temd-udevd[1349]: renamed network interface eth1 to eth9=0A[   10.549265] s=
ystemd-udevd[1314]: renamed network interface eth0 to eth5=0A[   10.558005]=
 omap-des 53701000.des: _od_fail_runtime_resume: FIXME: missing hwmod/omap_=
dev info=0A[   10.567243] omap-des 53701000.des: omap_des_probe: failed to =
get_sync(-19)=0A[   10.574491] omap-des 53701000.des: initialization failed=
=2E=0A[   10.783438] input: matrix_keypad@0 as /devices/matrix_keypad@0/inp=
ut/input2=0A[   10.918790] net eth5: initializing cpsw version 1.15 (0)=0A[=
   10.999811] net eth5: phy found : id is : 0x221621=0A[   11.126578] net e=
th9: initializing cpsw version 1.15 (0)=0A[   11.209371] net eth9: phy foun=
d : id is : 0x221621=0A=0ADebian GNU/Linux jessie/sid saruman ttyO0=0A=0Asa=
ruman login: root[   13.600100] xhci-hcd xhci-hcd.0.auto: xHCI Host Control=
ler=0A[   13.622719] xhci-hcd xhci-hcd.0.auto: new USB bus registered, assi=
gned bus number 1=0A[   13.637659] xhci-hcd xhci-hcd.0.auto: irq 206, io me=
m 0x483d0000=0A[   13.668909] usb usb1: New USB device found, idVendor=3D1d=
6b, idProduct=3D0002=0A[   13.676150] usb usb1: New USB device strings: Mfr=
=3D3, Product=3D2, SerialNumber=3D1=0A[   13.683863] usb usb1: Product: xHC=
I Host Controller=0A[   13.689052] usb usb1: Manufacturer: Linux 3.15.0-nex=
t-20140610-00002-g3853d91-dirty xhci-hcd=0A[   13.697863] usb usb1: SerialN=
umber: xhci-hcd.0.auto=0A[   13.743942] hub 1-0:1.0: USB hub found=0A[   13=
=2E749155] hub 1-0:1.0: 1 port detected=0A[   13.764403] xhci-hcd xhci-hcd.=
0.auto: xHCI Host Controller=0A[   13.772413] xhci-hcd xhci-hcd.0.auto: new=
 USB bus registered, assigned bus number 2=0A[   13.787532] usb usb2: New U=
SB device found, idVendor=3D1d6b, idProduct=3D0003=0A[   13.794835] usb usb=
2: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1=0A[   13.=
802450] usb usb2: Product: xHCI Host Controller=0A[   13.807552] usb usb2: =
Manufacturer: Linux 3.15.0-next-20140610-00002-g3853d91-dirty xhci-hcd=0A[ =
  13.816393] usb usb2: SerialNumber: xhci-hcd.0.auto=0A[   13.832308] hub 2=
-0:1.0: USB hub found=0A[   13.836727] hub 2-0:1.0: 1 port detected=0A=0ALa=
st login: Sat Jan  1 00:00:13 UTC 2000 on ttyO0=0ALinux saruman 3.15.0-next=
-20140610-00002-g3853d91-dirty #199 SMP Fri Jun 13 18:21:45 CDT 2014 armv7l=
=0A=0AThe programs included with the Debian GNU/Linux system are free softw=
are;=0Athe exact distribution terms for each program are described in the=
=0Aindividual files in /usr/share/doc/*/copyright.=0A=0ADebian GNU/Linux co=
mes with ABSOLUTELY NO WARRANTY, to the extent=0Apermitted by applicable la=
w.=0A[   15.209849] cpsw 4a100000.ethernet eth9: Link is Up - 1Gbps/Full - =
flow control rx/tx=0Aroot@saruman:~# ifconfig -a=0Aeth5      Link encap:Eth=
ernet  HWaddr 34:b1:f7:31:36:c8  =0A          UP BROADCAST MULTICAST  MTU:1=
500  Metric:1=0A          RX packets:0 errors:0 dropped:0 overruns:0 frame:=
0=0A          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0=0A      =
    collisions:0 txqueuelen:1000 =0A          RX bytes:0 (0.0 B)  TX bytes:=
0 (0.0 B)=0A          Interrupt:72 =0A=0Aeth9      Link encap:Ethernet  HWa=
ddr 34:b1:f7:31:36:ca  =0A          inet addr:192.168.1.11  Bcast:192.168.1=
=2E255  Mask:255.255.255.0=0A          UP BROADCAST RUNNING MULTICAST  MTU:=
1500  Metric:1=0A          RX packets:41 errors:0 dropped:0 overruns:0 fram=
e:0=0A          TX packets:44 errors:0 dropped:0 overruns:0 carrier:0=0A   =
       collisions:0 txqueuelen:1000 =0A          RX bytes:6926 (6.7 KiB)  T=
X bytes:5372 (5.2 KiB)=0A=0Alo        Link encap:Local Loopback  =0A       =
   inet addr:127.0.0.1  Mask:255.0.0.0=0A          UP LOOPBACK RUNNING  MTU=
:65536  Metric:1=0A          RX packets:8 errors:0 dropped:0 overruns:0 fra=
me:0=0A          TX packets:8 errors:0 dropped:0 overruns:0 carrier:0=0A   =
       collisions:0 txqueuelen:0 =0A          RX bytes:1104 (1.0 KiB)  TX b=
ytes:1104 (1.0 KiB)=0A=0Aroot@saruman:~# dhclient =08=08=08=08=08=08=08=08=
=08ping www.google.com=0APING www.google.com (74.125.227.148) 56(84) bytes =
of data.=0A64 bytes from dfw06s17-in-f20.1e100.net (74.125.227.148): icmp_s=
eq=3D1 ttl=3D250 time=3D6.76 ms=0A64 bytes from dfw06s17-in-f20.1e100.net (=
74.125.227.148): icmp_seq=3D2 ttl=3D250 time=3D6.90 ms=0A64 bytes from dfw0=
6s17-in-f20.1e100.net (74.125.227.148): icmp_seq=3D3 ttl=3D250 time=3D7.03 =
ms=0A64 bytes from dfw06s17-in-f20.1e100.net (74.125.227.148): icmp_seq=3D4=
 ttl=3D250 time=3D7.08 ms=0A^C=0A--- www.google.com ping statistics ---=0A4=
 packets transmitted, 4 received, 0% packet loss, time 3004ms=0Artt min/avg=
/max/mdev =3D 6.765/6.946/7.083/0.123 ms=0Aroot@saruman:~# startx=0A=0A=0AX=
=2EOrg X Server 1.15.1=0ARelease Date: 2014-04-13=0AX Protocol Version 11, =
Revision 0=0ABuild Operating System: Linux 3.13-1-armmp-lpae armv7l Debian=
=0ACurrent Operating System: Linux saruman 3.15.0-next-20140610-00002-g3853=
d91-dirty #199 SMP Fri Jun 13 18:21:45 CDT 2014 armv7l=0AKernel command lin=
e: console=3DttyO0,115200n8 root=3D/dev/mmcblk0p2 rw rootfstype=3Dext4 root=
wait=0ABuild Date: 15 April 2014  08:03:46PM=0Axorg-server 2:1.15.1-1 (http=
://www.debian.org/support) =0ACurrent version of pixman: 0.32.4=0A	Before r=
eporting problems, check http://wiki.x.org=0A	to make sure that you have th=
e latest version.=0AMarkers: (--) probed, (**) from config file, (=3D=3D) d=
efault setting,=0A	(++) from command line, (!!) notice, (II) informational,=
=0A	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.=0A(=3D=3D=
) Log file: "/var/log/Xorg.0.log", Time: Mon Jun 16 14:29:29 2014=0A(=3D=3D=
) Using config directory: "/etc/X11/xorg.conf.d"=0A(=3D=3D) Using system co=
nfig directory "/usr/share/X11/xorg.conf.d"=0AInitializing built-in extensi=
on Generic Event Extension=0AInitializing built-in extension SHAPE=0AInitia=
lizing built-in extension MIT-SHM=0AInitializing built-in extension XInputE=
xtension=0AInitializing built-in extension XTEST=0AInitializing built-in ex=
tension BIG-REQUESTS=0AInitializing built-in extension SYNC=0AInitializing =
built-in extension XKEYBOARD=0AInitializing built-in extension XC-MISC=0AIn=
itializing built-in extension SECURITY=0AInitializing built-in extension XI=
NERAMA=0AInitializing built-in extension XFIXES=0AInitializing built-in ext=
ension RENDER=0AInitializing built-in extension RANDR=0AInitializing built-=
in extension COMPOSITE=0AInitializing built-in extension DAMAGE=0AInitializ=
ing built-in extension MIT-SCREEN-SAVER=0AInitializing built-in extension D=
OUBLE-BUFFER=0AInitializing built-in extension RECORD=0AInitializing built-=
in extension DPMS=0AInitializing built-in extension Present=0AInitializing =
built-in extension DRI3=0AInitializing built-in extension X-Resource=0AInit=
ializing built-in extension XVideo=0AInitializing built-in extension XVideo=
-MotionCompensation=0AInitializing built-in extension SELinux=0AInitializin=
g built-in extension XFree86-VidModeExtension=0AInitializing built-in exten=
sion XFree86-DGA=0AInitializing built-in extension XFree86-DRI=0AInitializi=
ng built-in extension DRI2=0ALoading extension GLX=0A=0A=0A=0A^Cxinit: conn=
ection to X server lost=0A=0Awaiting for X server to shut down (EE) Server =
terminated successfully (0). Closing log file.=0A=0Axinit: unexpected signa=
l 2=0Aroot@saruman:~# =0Aroot@saruman:~# =0Aroot@saruman:~#=20
--LQksG6bCIzRHxTLp--

--BwCQnh7xodEAoBMC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTnwD8AAoJEIaOsuA1yqREq0EP/RSwKPsyD7R2BSAbY8XSwbhL
8mq7JM7GDyHGy6nDjjdBMU4+t/eGIS6ED+hspQrAo7a7GSbQ2WdV0gXnaLciic9s
A11SNyJH81/m1UFV0F6wU5BmbLG2NxFXMmr++gYjV3o05ah0guTBz8KzHQMhQDzT
P0qSwuNWSnG7AOJ8FnfJ1f8VLgybqH4WF5x8jlhzxLENVLao7eH9XDhGjuAvzpv8
VFoR+EGT4uPsebZr6RcB9Likbi4kTpzX44eORUnj/dea84jr05Wyf1+0I/CGeR1y
ScsoDmafGo8RANbx5Y5x12MmkSN2bnDXqeXN1Eo4GCjamMMO/d5CsCoB4MYNkwrq
7BjZyUWJKVzUEsfRyFeU2rVFDje1lCIOaL5p1VWHOtK2bZwdMJGcazvu7OKb2+/1
GsFn0JYvm+zyn6Zijk1G/LPgVHkkh8KOr/2Xzwv9t5Vh2KqTK5AnrVLXMiOUPFoW
DWlSBO2UHggHkvsgPFtTAm5VDiXln+QVBFlSUUtst/KSJ3nFSwKTU6giY20kCn0R
x6Hwcea6hSKF9Fk04rQyaBaVWHjWeBhvvq5FfxwE+SM9PfyvLKNtyTyVrlpR0N45
YBSrnrgzARECXZTiEgNtR0ehXi5mZhGE2QhGcHE5IXFBeUdeZ6FS+nTvXgiTjDe9
KKOc7AdMZt46b1uHl19S
=mElL
-----END PGP SIGNATURE-----

--BwCQnh7xodEAoBMC--
