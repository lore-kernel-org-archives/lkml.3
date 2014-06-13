Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaFMOKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 10:10:52 -0400
Received: from smtprelay4.synopsys.com ([198.182.44.111]:38382 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbaFMOKt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 10:10:49 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Rob Herring <robherring2@gmail.com>
CC: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Jiri Slaby" <jslaby@suse.cz>, Paul Bolle <pebolle@tiscali.nl>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "Francois.Bedard@synopsys.com" <Francois.Bedard@synopsys.com>
Subject: Re: [PATCH 9/9] serial/arc: Add DT based earlycon support
Thread-Topic: [PATCH 9/9] serial/arc: Add DT based earlycon support
Thread-Index: AQHPhinUnAXEFucMI0aUKI8MUvq0Qg==
Date: Fri, 13 Jun 2014 14:10:41 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA230751A6B772C@IN01WEMBXA.internal.synopsys.com>
References: <1402569099-9900-1-git-send-email-vgupta@synopsys.com>
 <1402569099-9900-10-git-send-email-vgupta@synopsys.com>
 <CAL_Jsq+wf-nwzw_sYk4FiZxRr2advvjkd7i32arqVAFptDeVGA@mail.gmail.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.196.93]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 June 2014 06:57 AM, Rob Herring wrote:
> On Thu, Jun 12, 2014 at 5:31 AM, Vineet Gupta
> <Vineet.Gupta1@synopsys.com> wrote:
>> > Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
>> > ---
> Nice series!
>
>> >  arch/arc/boot/dts/angel4.dts  | 3 ++-
>> >  drivers/tty/serial/arc_uart.c | 1 +
>> >  2 files changed, 3 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/arch/arc/boot/dts/angel4.dts b/arch/arc/boot/dts/angel4.dts
>> > index 6b57475967a6..e9fc270d1e0b 100644
>> > --- a/arch/arc/boot/dts/angel4.dts
>> > +++ b/arch/arc/boot/dts/angel4.dts
>> > @@ -17,7 +17,8 @@
>> >         interrupt-parent = <&intc>;
>> >
>> >         chosen {
>> > -               bootargs = "earlycon=arc_uart,mmio32,0xc0fc1000,115200n8 console=ttyARC0,115200n8";
>> > +               bootargs = "earlycon console=ttyARC0,115200n8";
>> > +               stdout-path = &arcuart0;
> Just FYI, Grant has a series to pickup the normal console from
> stdout-path which would mean you can remove console param as well.
> I've kicked him to respin it.

OK ! I can split up 9/9 into driver chg and DT change.

In the mean time could you take a look at the driver patches which switch to
earlycon and DT earlycon
and possibly provide Ack/Reviewed by.

Thx,
-Vineet
