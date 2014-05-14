Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbaENHMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 03:12:47 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:33624 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbaENHMm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 03:12:42 -0400
MIME-Version: 1.0
X-Originating-IP: [95.23.101.217]
In-Reply-To: <CF9849B0.24764%john3909@gmail.com>
References: <1399686184-1594-1-git-send-email-mranostay@gmail.com>
	<20140512195050.GB5668@atomide.com>
	<CAOCHtYiYwx_bEsyqkbUTTAbhBYESzvfBOOYeVuFXPS1dDy0ZKA@mail.gmail.com>
	<20140512201517.GC5668@atomide.com>
	<CAOCHtYg6XpF0Gbo4iFqsFvP=QSivQQvCzov8UfxeLXMzrRYEWw@mail.gmail.com>
	<20140512204213.GD5668@atomide.com>
	<CAOCHtYgg7jwxswH+mqF3RA7-0RP-nGuft+Ze-GRwu1fbA6+0Bw@mail.gmail.com>
	<537215D3.70306@ti.com>
	<CABxcv=nq9XvyN0aPOBFDm0UyoaW-Htyy0tyP3YhYaDnDUo3a5w@mail.gmail.com>
	<20140513142252.GG32082@beef>
	<CABxcv=mSs71pS1PAS-WdP0ru_Eb1XhXEm1qCCKW7=aL7EN4FgQ@mail.gmail.com>
	<4BCFCB24-9732-4B96-B814-5290CA2D0EE4@gmail.com>
	<CABxcv=mWqENSzODJYAJRgDYNy46X6WkQ+0e4NSDt8qE-ob1KuQ@mail.gmail.com>
	<CF97C6D2.246DE%john3909@gmail.com>
	<2A5F30DB-EF92-4CFC-BA3C-4ECAE36FD4FF@gmail.com>
	<CF9849B0.24764%john3909@gmail.com>
Date: Wed, 14 May 2014 09:12:41 +0200
Message-ID: <CABxcv=mZdhDGA8K_QDHWnt65Z3mjNdgbm76pd6U7omK7M1F6gQ@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: dts: am335x-bone-common: Add i2c2 definition
From: Javier Martinez Canillas <javier@dowhile0.org>
To: John Syn <john3909@gmail.com>
Cc: Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Matt Porter <matt.porter@linaro.org>, Tom Rini <trini@ti.com>,
        Robert Nelson <robertcnelson@gmail.com>,
        Tony Lindgren <tony@atomide.com>, Matt Ranostay <mranostay@gmail.com>,
        robh+dt@kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jhon,

On Wed, May 14, 2014 at 7:44 AM, John Syn <john3909@gmail.com> wrote:
>
> On 5/13/14, 8:39 PM, "Pantelis Antoniou" <pantelis.antoniou@gmail.com>
> wrote:
>
>>Hi John,
>>
>>On May 13, 2014, at 1:24 PM, John Syn wrote:
>>
>>>
>>> On 5/13/14, 10:51 AM, "Javier Martinez Canillas" <javier@dowhile0.org>
>>> wrote:
>>>
>>>> Hello Pantelis,
>>>>
>>>> On Tue, May 13, 2014 at 7:07 PM, Pantelis Antoniou
>>>> <pantelis.antoniou@gmail.com> wrote:
>>>>> Hi Javier,
>>>>>
>>>>> On May 13, 2014, at 7:39 AM, Javier Martinez Canillas wrote:
>>>>>
>>>>>> On Tue, May 13, 2014 at 4:22 PM, Matt Porter <matt.porter@linaro.org>
>>>>>> wrote:
>>>>>>> On Tue, May 13, 2014 at 04:06:02PM +0200, Javier Martinez Canillas
>>>>>>> wrote:
>>>>>>>> On Tue, May 13, 2014 at 2:53 PM, Tom Rini <trini@ti.com> wrote:
>>>>>>>>> On 05/12/2014 04:57 PM, Robert Nelson wrote:
>>>>>>>>>>>> Either case if fine with me.  As who knows when the dtc
>>>>>>>>>>>> "overlay" will
>>>>>>>>>>>> every truly make it mainline, as the capemgr was the only real
>>>>>>>>>>>> kernel
>>>>>>>>>>>> user of the i2c/at24 eeprom information.
>>>>>>>>>>>
>>>>>>>>>>> Sounds like we should keep it disabled though so u-boot can be
>>>>>>>>>>> used
>>>>>>>>>>> to toggle it while waiting for the capemgr. That's because the
>>>>>>>>>>> board
>>>>>>>>>>> has a header for pins, so it's not exactly limited to just the
>>>>>>>>>>> capes.
>>>>>>>>>>>
>>>>>>>>>>> Anybody working on enabling/disabling cape dtb configurations in
>>>>>>>>>>> u-boot?
>>>>>>>>>>
>>>>>>>>>> Well,
>>>>>>>>>>
>>>>>>>>>> Would Tom even approve of that in mainline u-boot? He didn't want
>>>>>>>>>> my
>>>>>>>>>> "invert" the gpio to enable the usb hub on the older beagle xm
>>>>>>>>>> A/B..
>>>>>>>>>>
>>>>>>>>>> http://lists.denx.de/pipermail/u-boot/2014-January/172154.html
>>>>>>>>>>
>>>>>>>>>> http://lists.denx.de/pipermail/u-boot/2014-January/172274.html
>>>>>>>>
>>>>>>>> Using fdt set from the bootloader to use the same FDT for similar
>>>>>>>> boards (like the example with Beagle xM variants) is kind of trying
>>>>>>>> to
>>>>>>>> replicate what we used to do from boards files where it was
>>>>>>>>possible
>>>>>>>> to manage a set of boards using the same platform code.
>>>>>>>>
>>>>>>>> But Device Trees are meant to describe hardware and thus should be
>>>>>>>> static, if two board are almost identical but slightly different,
>>>>>>>> then
>>>>>>>> are two different hardware where each need its proper FDT that
>>>>>>>> describes it.
>>>>>>>>
>>>>>>>>>
>>>>>>>>> I would think that using the 'fdt' command in U-Boot to add all
>>>>>>>>> properties of every cape found on a running system would drive
>>>>>>>>> someone
>>>>>>>>> to madness quite quickly.  Moving all of Pantelis' work for
>>>>>>>>>dynamic
>>>>>>>>> device trees from the kernel to N bootloaders (U-Boot, barebox,
>>>>>>>>> UEFI,
>>>>>>>>> etc) sounds like a step in the wrong direction.
>>>>>>>>>
>>>>>>>>
>>>>>>>> Agreed. I think that until the device tree overlay and the cape
>>>>>>>> manager find their way into mainline we should treat capes as if
>>>>>>>>they
>>>>>>>> were expansion boards attached to a Computer-on-Module. That is, a
>>>>>>>> static based board which its own DTS including the BB{B,W} as an
>>>>>>>>dtsi
>>>>>>>> and not something that can be added on runtime.
>>>>>>>
>>>>>>> It's far more complicated than a SOM plus carrier board. Consider
>>>>>>>that
>>>>>>> you can have any 4 of these capes stacked on the BBB/BBW in any
>>>>>>> combination (assuming no resource conflicts). Capturing all possible
>>>>>>> combinations in static dtsis is not practical.
>>>>>>>
>>>>>>
>>>>>
>>>>> Since this appears to be all coming back to DT overlays, let me try to
>>>>> address some points.
>>>>>
>>>>
>>>> It seems that you misunderstood my comments. I do think that DT
>>>> overlays and the cape manager are a great solution for any hardware
>>>> that could be expanded on runtime and I really hope that they can
>>>> eventually land into mainline.
>>>>
>>>> In fact if you look on my previous mail you will see that I said:
>>>> "until device tree overlay and the cape manager find their way into
>>>> mainline..."
>>>>
>>>>>> Right, I forgot that the capes were stackable so is indeed not
>>>>>> practical to model every single combination as DTS in mainline. Even
>>>>>> if stacking was not possible there are just too many capes out there
>>>>>> to have a DTS for every single cape.
>>>>>>
>>>>>
>>>>> Each cape does have a DTS as dynamically loaded fragment; it works
>>>>> absolutely fine.
>>>>>
>>>>> Trying to come up with a base DTS for all the capes you've stacked up
>>>>> is an exponential problem.
>>>>>
>>>>>> My point was that someone who wants to use a BBB + a set of capes can
>>>>>> today write a DTS for its own stacked setup.
>>>>>>
>>>>>
>>>>> No, the guy that designs a cape (or learns how to) can not write a DTS
>>>>> for
>>>>> the base board and the cape in question. Doing that he essentially
>>>>>cuts
>>>>> himself off from the community.
>>>>>
>>>>> Let me explain, the point is for people to easily design capes,
>>>>> open-source their
>>>>> design as well as their software, and share them to the community.
>>>>>
>>>>> This requires that things are easily shareable.
>>>>>
>>>>> Requiring a relative newbie in kernel development not only generate
>>>>>his
>>>>> own
>>>>> base DT, but also to merge all of the other capes DT into his own is a
>>>>> nightmare.
>>>>>
>>>>> BTW, on another tangent, it's not just the BB people that care about
>>>>> dynamic
>>>>> hardware configuration. There are a number of FPGA people that seem
>>>>> interested
>>>>> as well.
>>>>>
>>>>> The notion of hardware as something static that never changes is
>>>>> obsolete IMHO.
>>>>>
>>>>>> Unfortunately I don't have a solution but what I'm pretty sure is
>>>>>>that
>>>>>> mangling the DTS from the bootloader is not the right one :-)
>>>>>>
>>>>>
>>>>> No, it is not. And this is what we're trying to solve here.
>>>>>
>>>>
>>>> What I said that I'm against is modifying a FDT using U-Boot scripts
>>>> commands that is something that mentioned in this thread. That is not
>>>> a robust way to do it and also is not something that a newbie could do
>>>> it neither.
>>>>
>>>> Also, doing these FDT changes in the bootloader has several
>>>> disadvantages, besides having to implement on each bootloaders like
>>>> Tom said, you need to upgrade your bootloader which is something that
>>>> just can't be done on many boards and also is still a static
>>>> configuration since you need to reboot in order to use a different
>>>> FDT. So the hardware can't really be expanded on runtime unlike with
>>>> DT overlays where the overlays are loaded from regular files.
>>>>
>>>> But I guess you agree with me on all those points and you just
>>>> misunderstood my comments. So DT overlays is definitely the way to go
>>>> (or something similar) but my point is that until we have that
>>>> solution merged, you can use a static DT in mainline for your stacked
>>>> cape or use a vendor kernel that already has DT overlays support.
>>>
>>> Given that we are not hot plugging capes, why do we need to modify the
>>>DT
>>> at runtime? Even FPGA developers are not modifying their I/O at runtime.
>>> For example, using the BBB as a reference, why not add an
>>>am335x-cape-dtsi
>>> to the am335x-boneblack.dts as follows:
>>>
>>> /dts-v1/;
>>>
>>> /include/ "am33xx.dtsi"
>>>
>>> /include/ "am335x-bone-common.dtsi²
>>>
>>> /include/ ³am335x-cape.dtsi"
>>>
>>> &am33xx_pinmux {
>>> xxx
>>>
>>> and ³am335x-cape.dtsi² would look like this:
>>>
>>> /include/ ³BB-BONE-AUDI-00A0.dtsi²
>>> /include/ ³BB-BONE-UART1-00A0.dtsi²
>>> xxx
>>>
>>> So, cape developers create their own DTSI and users only update the
>>> am335x-cape.dtsi to include the cape DT required.
>>>
>>> What am I missing?
>>>
>>> BTW, DTC should be updated to detect I/O conflicts. Waiting for the
>>>kernel
>>> to boot before detecting DT conflicts isn¹t OK.
>>>
>>> Regards,
>>> John
>>>
>>>
>>
>>For a single cape that's fine.
>>
>>Now handle the case where your cape must work with any kind of cape
>>combination with a same
>>kernel+dtb+rootfs image.
>>
>>The point is that you want to get each cape developer contribute back to
>>the official release,
>>and to get people to use your stuff without recompiling anything.
>>
>>No-one making distro-releases is willing to handle a few dozens of DTBs
>>for all the combinations.
> Hi Pantelis,
>
> I’m not sure I understand the “single cape” comment. If a developer
> modifies the cape DTSI (e.g. am335x-cape.dtsi) and include definitions for
> all attached capes, surely this will work for any combinations of capes.
> From your explanation, it seems you don’t want the developer to run DTC,
> but you are OK with updating the uEnv.txt file or modifying some cape
> manager script file to load the DT overlays at boot time.
>

What I think Pantelis meant is that is not an ideal solution to force
users to write &&|| modify a single DT for any combination of capes.
It is much easier to have a base dts and a set of DT fragments that
can be overlayed in runtime.

Also I don't see where he said that he is ok with the DT mangling from
u-boot, in fact I guess Pantelis is not fond about that idea and
that's why he wrote the DT overlays support ;-)

Maybe you are confusing how DT overlays and the cape manager work? The
former is an extension to OF in order to support the concept of
fragments that can be overlayed on top of a current tree and the later
is an in-kernel mechanism to load the cape dtb with the DT fragment
that is going to be overlayed.

There is no bootloader involved, the DT overlay happens on runtime and
is the kernel the one that loads the dtb fragments in a similar way
that loads firmware today.

> Until DT overlay makes it into mainline, wouldn’t the cape DTSI solution
> suffice for now? Can some component that is initally disabled (status =
> “disabled") be enabled (status = “okay”) via one of the cape DTSI
> referenced in am335x-cape.dtsi? I prefer not to pollute u-boot with DT
> info because synching u-boot and the kernel could be a nightmare.
>

I agree with you on that regard. Until DT overlays makes into mainline
a user that does not want to use a vendor tree with DT overlays
support can write its own DTS which describes a stacked BBB + cape* as
if it was just a single fixed board with all those peripherals.

No need to modify the compiled DTB from U-Boot before passing to the kernel.

> Regards,
> John
>>

Best regards,
Javier
