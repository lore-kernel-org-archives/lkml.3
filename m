Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbaHDWt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 18:49:58 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:32813 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaHDWt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 18:49:57 -0400
MIME-Version: 1.0
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E0304844C411C@US01WEMBX2.internal.synopsys.com>
References: <CAPDOMVj5nifG8VQBB_UzNESBc+arxpCQ5sEOAYdb6Rr-KkDSHw@mail.gmail.com>
	<20140804164633.GA28436@xanatos>
	<A2CA0424C0A6F04399FB9E1CD98E0304844C4028@US01WEMBX2.internal.synopsys.com>
	<58974.1407180184@turing-police.cc.vt.edu>
	<A2CA0424C0A6F04399FB9E1CD98E0304844C4061@US01WEMBX2.internal.synopsys.com>
	<62334.1407184063@turing-police.cc.vt.edu>
	<A2CA0424C0A6F04399FB9E1CD98E0304844C411C@US01WEMBX2.internal.synopsys.com>
Date: Mon, 4 Aug 2014 18:49:56 -0400
Message-ID: <CAPDOMViK3ZzeDhNMi9oX_s8kZG45BGPwbmZeoT4u-nqg2rgwSg@mail.gmail.com>
Subject: Re: Kernel Debugging Support
From: Nick Krause <xerofoify@gmail.com>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
Cc: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "Nyman, Mathias" <mathias.nyman@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 4, 2014 at 5:55 PM, Paul Zimmerman
<Paul.Zimmerman@synopsys.com> wrote:
>> From: Valdis.Kletnieks@vt.edu [mailto:Valdis.Kletnieks@vt.edu]
>> Sent: Monday, August 04, 2014 1:28 PM
>>
>> On Mon, 04 Aug 2014 19:40:15 -0000, Paul Zimmerman said:
>>
>> > Ah, you didn't read far enough down the page :)
>>
>> I'm willing to bet a large pizza with everything but anchovies that
>> out in the real world, a lot of implementors didn't read further either. :)
>
> Nah, I won't take that bet :)
>
>> > So I have to believe there are a *lot* of systems out there that do support xHCI debug.
>>
>> Possibly. But enough to make an actual critical mass to motivate somebody
>> to write code? Or do you get more bang-for-buck by fixing kgdb to support
>> debugging over Ethernet?
>
> Well, code to support the xHCI debug capability has been written, see
> http://marc.info/?l=linux-usb&m=135948845511047. But I did not get
> approval from my management to spend the time needed to integrate this
> into the kernel's kgdb support.
>
> Nick, if you are still interested in this, you could take a look at the
> above code, and see if you can work out how to modify it to make it work
> with kgdb. But you will need a PC that has a debug-capable xHCI
> controller in order to test it. If you have PC or laptop with USB 3.0
> built-in that has the Windows 8 logo, I think there's a good chance you
> already have one. Or, according to
> http://pete.akeo.ie/2011/08/do-necrenesas-upd720200-based-usb-30.html,
> plug-in USB 3.0 host cards that use the newer Renesas uPD720201 chipset
> also have the debug capability.
>
> Note that the above patch is against a pretty old kernel (3.6), so the
> first thing you would need to do is forward-port it to work on the
> latest kernel. As a plus, that would give you some real experience
> working with kernel code, which everyone seems to agree you need ;)
>
> --
> Paul
>

Paul ,
My computer is rather old now as of Sandy Bridge days, so I probably
can't test the patch
on my own machine. However I will look at the code and see if I can
forward port it
against the usb git tree I have a current version of. In addition I
would like the new xhci
maintainers information in  order to send out a patch with the
Maintainer for xhci updated.
Regards Nick
