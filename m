Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab3I0N5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:57:36 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:22539 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab3I0N5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:57:30 -0400
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Sep 2013 09:57:29 EDT
X-AuditID: cbfec373-b7f6d6d00000330d-c1-52458c6fcefd
Date: Fri, 27 Sep 2013 10:47:19 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] media: rc: OF: Add Generic bindings for remote-control
Message-id: <20130927104719.6637368f@samsung.com>
In-reply-to: <20130927113458.GB18672@e106331-lin.cambridge.arm.com>
References: <1380274391-26577-1-git-send-email-srinivas.kandagatla@st.com>
 <20130927113458.GB18672@e106331-lin.cambridge.arm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t/hYN38Htcgg4ZlrBbzj5xjtTj3aiWj
	xcK2JSwWl3fNYbPo2bCV1WLp9YtMFhOmr2WxOLziAJPFupfTWSymPOtltXh1sI3Fgdtjzbw1
	jB4LPl9h91i5/Aubx6vVM1k9nv7Yy+zxeZOcx8a5oQHsUVw2Kak5mWWpRfp2CVwZtx8tZSw4
	bF/xfsN8xgbGfqMuRk4OCQETiasTT7NC2GISF+6tZ+ti5OIQEljCKNG6fwsrhNPDJHFkazs7
	SBWLgKrErq/zmEBsNgEjiVeNLWDdIgLqEj27vrCANDAL/GWWWLjuHFCCg0NYwF/ieg9YL6+A
	ocTjJ2vAejkFnCWOP7nADLGgmVHizfkTjCD1EgJOElun+kLUC0r8mHyPBcRmFtCS2LytiRXC
	lpfYvOYt8wRGgVlIymYhKZuFpGwBI/MqRtHS4uSC4qT0XCO94sTc4tK8dL3k/NxNjJAIKd7B
	+GKD1SFGAQ5GJR5egQyXICHWxLLiytxDjBIczEoivCKdrkFCvCmJlVWpRfnxRaU5qcWHGJk4
	OKUaGHkysuTm2/pXr77Edv3fnMSsvPBX4nnMIaGBBT7ebio/v9xk+6+/omn5tAV/3r9lW/A8
	0/iZZbGMa9t06e63H7j11S6L9iVnvSs3Ue38PP2pzr8AtVf3N8iWbpwWP6vsqVu2kH3clbt6
	W0/en3Z34tKahwvjdt6fdHDmrnaLj6HrDll7Vph9vKXEUpyRaKjFXFScCABT/Eq5bgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 27 Sep 2013 12:34:58 +0100
Mark Rutland <mark.rutland@arm.com> escreveu:

> On Fri, Sep 27, 2013 at 10:33:11AM +0100, Srinivas KANDAGATLA wrote:
> > From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> > 
> > This patch attempts to collate generic bindings which can be used by
> > the remote control hardwares. Currently the list is not long as there
> > are only 2 drivers which are device tree'd.
> > 
> > Mainly this patch tries to document few bindings used by ST IRB driver
> > which can be generic as well. This document also add fews common
> > bindings used by most of the drivers like, interrupts, regs, clocks and
> > pinctrls.
> > 
> > This document can also be holding place to describe generic bindings
> > used in remote controls devices.
> > 
> > Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> > ---
> > Hi All, 
> > Following Stephen Warren's suggestions at https://lkml.org/lkml/2013/9/24/452
> > this patch is an attempt to document such generic bindings in a common
> > document.
> > 
> > This document currently collates all the generic bindings used with
> > remote-controls and act as holding place to describe generic bindings for
> > remote controls.
> > 
> > Comments?
> > 
> > Thanks,
> > srini
> > 
> >  .../devicetree/bindings/media/remote-control.txt   |   31 ++++++++++++++++++++
> >  1 files changed, 31 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/media/remote-control.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/media/remote-control.txt b/Documentation/devicetree/bindings/media/remote-control.txt
> > new file mode 100644
> > index 0000000..901ea56
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/remote-control.txt
> > @@ -0,0 +1,31 @@
> > +Generic device tree bindings for remote control.
> > +
> > +properties:
> > +	- compatible: Can contain any remote control driver compatible string.
> > +	  example: "st-comms-irb, "gpio-ir-receiver".
> 
> This is more generic than remote control, could this not just be left
> for the specific binding to describe?
> 
> > +	- reg: Base physical address of the controller and length of memory
> > +	  mapped region.
> 
> What if it's on a bus that isn't memory mapped (e.g. i2c, SPI)?
> 
> > +	- interrupts: Interrupt-specifier for the sole interrupt generated by
> > +	  the device. The interrupt specifier format depends on the
> > +	  interrupt controller parent. Iff the device supports interrupts.
> 
> What if it has multiple interrupts, and has interrupts-names?
> 
> It might be better to only describe the properties that relate
> specifically to remote controls, rather than listing all of the generic
> properties that device tree bidnings may have. That would match the
> style of the clock bindings.
> 
> > +	- rx-mode: Can be "infrared" or "uhf". rx-mode should be present iff
> > +	  the rx pins are wired up.
> 
> I'm unsure on this. What if the device has multiple receivers that can
> be independently configured? 

Well, if a given remote controller hardware has more than one independent
receiver (or transmitter), each one should have its own devnode.
Likely, two entries at DT.

> What if it supports something other than
> "infrared" or "uhf"? What if a device can only be wired up as
> "infrared"? 

I would say that a hardware that has both infrared and uhf has actually
two different devices. So, it should be mapped as two separate devnodes.

> I'm not sure how generic these are, though we should certainly encourage
> bindings that can be described this way to be described in the same way.
> 
> > +	- tx-mode: Can be "infrared" or "uhf". tx-mode should be present iff
> > +	  the tx pins are wired up.
> 
> I have similar concerns here to those for the rx-mode property.
> 
> > +
> > +Optional properties:
> > +	- linux,rc-map-name: Linux specific remote control map name. Refer to
> > +	  include/media/rc-map.h for full list of maps.
> 
> We shouldn't refer to Linux specifics (i.e. headers) in general in
> bindings. While it's possible to relax that a bit for linux,*
> properties, I'd prefer to explicitly list elements in the binding. That
> prevents the ABI from changing under our feet by someone altering what
> looks like a completely internal header file.

Well, the remote controller keymaps at include/media/rc-map.h is just a
bunch of string names, defined as macro to avoid duplicating those names
everywhere, to avoid typos and to help some userspace parsing logic to get
all in just one single place. I don't see why the same names couldn't be 
used on any other OS using DT.

The logic behind include/media/rc-map.h, is that those names are used
by:

1) kernelspace: in order to locate a keytable with the same name, that
would be loaded when the device is initialized;

2) userspace: to seek for a keytable with that name, allowing to
dynamically load the keymap table on userspace, instead of hardwiring
them on Kernelspace (or replacing the kernel's one by an user-customized
one).

So, I would simply call it as "keymap-name", keep pointing it to 
include/media/rc-map.h.

That's said, this is actually a mandatory requirement, as without it,
the RC core will not be able to load a keytable, and the userspace tool
won't load the proper keymap, being confused on what to do.

It should be noticed that, from time to time, manufacturers change the
remote control unit, as those devices are generally manufactured by a
third part. So, they change, for example, when they get a new BID to
provide IRs for a cheaper cost, or when they need/want to provide a "deluxe"
remote, a simplified "thin" one and/or when they need to provide customized
remotes to some Cable company, for example.

So, it makes sense for it to be mandatory, as only with this information it
is possible to load the keymap that matches that specific IR unit model.

In other words, I would add this as a mandatory property, with a text
similar to:

	- keymap-name: Name of the keyboard scancode table used to match 
	  the remote controller unit model (or model set). Please add it at
	  include/media/rc-map.h for newer models.

It could be interesting to also warn there that, when the remotes are
made exclusively to a given hardware vendor, and the entries are not
incompatible, the same keymap name could be used by more than one remote
controller unit.

> > +	- pinctrl-names, pinctrl-0: The pincontrol settings to configure muxing
> > +	  properly for the device pins.
> > +	- clocks : phandle with clock-specifier pair for the device specified
> > +	  in compatible.
> 
> While devices may have these, they're also more general than remote
> control devices. I'm not sure that they need to be listed here when they
> need to be described fully in any binding that needs them anyway,
> especially as this gives an impression that they are valid for bindings
> that don't need them.
> 
> I think what we actually need to document is the process of creating a
> binding in such a way as to encourage uniformity. Something like the
> following steps:
> 
> 1. Look to see if a binding already exists. If so, use it.
> 
> 2. Is there a binding for a compatible device? If so, use/extend it.
> 
> 3. Is there a binding for a similar (but incompatible) device? Use it as
>    a template, possibly factor out portions into a class binding if
>    those portions are truly general.
> 
> 4. Is there a binding for the class of device? If so, build around that,
>    possibly extending it.
> 
> 5. If there's nothing relevant, create a binding aiming for as much
>    commonality as possible with other devices of that class that may
>    have bindings later.
> 
> Cheers,
> Mark.
> 
> > +
> > +example:
> > +
> > +	rc: rc@fe518000 {
> > +		compatible	= "st,comms-irb";
> > +		reg		= <0xfe518000 0x234>;
> > +		interrupts	= <0 203 0>;
> > +		rx-mode		= "infrared";
> > +	};
> > -- 
> > 1.7.6.5
> > 
> > 


-- 

Cheers,
Mauro
