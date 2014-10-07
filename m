Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbaJGLHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 07:07:35 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:41738 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386AbaJGLHd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 07:07:33 -0400
MIME-Version: 1.0
In-Reply-To: <85851374-20d5-400b-b773-ea6ba2acdaf7@BY2FFO11FD045.protection.gbl>
References: <c2b9a1c1-d3b9-48c5-9c14-a4c3a95965fa@BN1AFFO11FD046.protection.gbl>
	<20140925081748.GB26991@pengutronix.de>
	<85851374-20d5-400b-b773-ea6ba2acdaf7@BY2FFO11FD045.protection.gbl>
Date: Tue, 7 Oct 2014 13:07:33 +0200
Message-ID: <CACRpkdY7cGWDRRnMd_Ni_ptBpEoQsjFcNyDSfPhXYWk=SZ2_9Q@mail.gmail.com>
Subject: Re: [RFC] pinctrl driver for Zynq
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 6:02 PM, Sören Brinkmann
<soren.brinkmann@xilinx.com> wrote:
> On Thu, 2014-09-25 at 10:17AM +0200, Steffen Trumtrar wrote:
>> On Wed, Sep 24, 2014 at 02:09:14PM -0700, Sören Brinkmann wrote:

>> (...)
>>
>> > +                           pinctrl_sdio1_cd_54: pinctrl-sdio1_cd@54 {
>> > +                                   sdio1_cd-mux {
>> > +                                           function = "sdio1_cd";
>> > +                                           pins = "sdio1_emio_cd_grp";
>> > +                                   };
>> > +                           };
>> > +                   };
>> >             };
>> >
>>
>> Wouldn't this reaaally bloat the dtb?
>> I know that imx decided to remove all the pinctrls from the dtsis, because
>> the dtbs got to big.
>
> Yep, it absolutely does and I don't really know what to do about it.
> Listing them all is a lot. Not listing them all would force board DTs to
> potentially duplicate such nodes. This is definitely one of the things
> I'm seeking input on.
> Is there any good solution or best practice?

What about the middle road just putting those that are actually
used in some DTS file into the DTSI?

Else I vote for duplicating them in each DTS.

Yours,
Linus Walleij
