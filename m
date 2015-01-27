Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489AbbA0Pn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:43:56 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:47573 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbbA0Pnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:43:52 -0500
MIME-Version: 1.0
In-Reply-To: <20150127145518.GA32531@kroah.com>
References: <1422345407-10037-1-git-send-email-chunyan.zhang@spreadtrum.com>
	<2196748.ag4UzqF1Px@wuerfel>
	<20150127145518.GA32531@kroah.com>
Date: Tue, 27 Jan 2015 23:43:51 +0800
Message-ID: <CAAfSe-sPv+TDrUXYfW8DRJZiXjhVpRr=Wd3td7kHeB5r2LEnjw@mail.gmail.com>
Subject: Re: [PATCH v8 0/2] Add Spreadtrum SoC bindings and serial driver support
From: Lyra Zhang <zhang.lyra@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Chunyan Zhang <chunyan.zhang@spreadtrum.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>,
        Pawel Moll <pawel.moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "florian.vaussard@epfl.ch" <florian.vaussard@epfl.ch>,
        "andrew@lunn.ch" <andrew@lunn.ch>, Hayato Suzuki <hytszk@gmail.com>,
        "antonynpavlov@gmail.com" <antonynpavlov@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>, Orson Zhai <orsonzhai@gmail.com>,
        "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>,
        "zhizhou.zhang" <zhizhou.zhang@spreadtrum.com>,
        "lanqing.liu@spreadtrum.com" <lanqing.liu@spreadtrum.com>,
        =?UTF-8?B?V2VpIFFpYW8gKOS5lOS8nyk=?= <wei.qiao@spreadtrum.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 10:55 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Jan 27, 2015 at 02:24:02PM +0100, Arnd Bergmann wrote:
>> On Tuesday 27 January 2015 15:56:45 Chunyan Zhang wrote:
>> > This patch-set split the last version, and addressed the review comments from
>> > last version on serial driver code.
>> >
>> > Changes from v7:
>> > * Addressed review comments from Peter:
>> >         - Initialized the stack local with zero in sprd_set_termios()
>> >         - Used dev_get_drvdata() to get sprd_uart_port
>> >
>>
>> Looks good to me, but you still have too many people on 'To', so Greg
>> might be missing that you expect him to merge it.
>>
>> Greg, if there are no further comments, can you take both patches through
>> the tty git?
>
> Will do, thanks.
>
> greg k-h

To Arnd, Greg, Peter, and to all of others

thank you so much for your help.
You all gave us so many important comments and valuable suggestions
these months.

Best regards,
Chunyan
