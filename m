Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbaIBRiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 13:38:46 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:48158 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaIBRio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:38:44 -0400
MIME-Version: 1.0
In-Reply-To: <3749748.k4a1nSHDdj@wuerfel>
References: <1409328803-1953-1-git-send-email-andre.przywara@arm.com>
 <540596A6.8000608@arm.com> <CAL_Jsq+Rs5MXC7s7EeWAEAPxxqaShAVGt=cdQxud5Us+-Zp6jw@mail.gmail.com>
 <3749748.k4a1nSHDdj@wuerfel>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 2 Sep 2014 12:38:23 -0500
Message-ID: <CAL_JsqKGbSd5BymnFhT8KBjbBCPO8wsrHhG9Qn20c7mrrxTDDA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] drivers: introduce ARM SBSA generic UART driver
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2014 at 8:48 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 02 September 2014 08:20:53 Rob Herring wrote:
>> >>
>> >> This alone is not okay. There is no such implementation of hardware.
>> >
>> > But the SBSA explicitly allows this. I don't know of any vendor who just
>> > implements the subset, but I've been told that this has been asked for.
>>
>> To use baudrate as an example, that must be configurable somehow
>> either with pl011 registers or in a vendor specific way. I suppose you
>> could do an actual implementation with all those things hardcoded in
>> the design, but that seems unlikely.
>
> Why does the baudrate need to be configurable? I think it's completely
> reasonable to specify a console port that has a fixed (as in the
> OS must not care) rate, and that can be implemented either as a UART
> with a programmable rate or as a set of registers that directly talks
> to a remote system management device over whatever hardware protocol
> they choose.

Sure. It is also completely reasonable that baudrate is configurable
and vendors can implement it however they choose since the SBSA does
not specify it. IIRC, the enabling and disabling bits are not
specified either.

Not having configurability is simply one variation on possible implementations.

Rob
