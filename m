Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbaANSfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 13:35:36 -0500
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:39978 "HELO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751526AbaANSfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 13:35:34 -0500
MIME-Version: 1.0
In-Reply-To: <201401140706.13406.arnd@arndb.de>
References: <1389135041-16062-1-git-send-email-fkan@apm.com>
	<201401132043.52491.arnd@arndb.de>
	<CAL85gmCA4kBsRUMC_ENjGfCq5jM11iY5Jx_+A3V9XQDU0b7E0A@mail.gmail.com>
	<201401140706.13406.arnd@arndb.de>
Date: Tue, 14 Jan 2014 10:35:33 -0800
Message-ID: <CAL85gmD+34VKSHsGXWTbQ2w3razo_cKukfe=dSQJi+x-Zfvtpw@mail.gmail.com>
Subject: Re: [PATCH V2 1/6] Documentation: add dts binding for X-Gene reboot
 dts node.
From: Feng Kan <fkan@apm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 10:06 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 14 January 2014, Feng Kan wrote:
>>
>> >
>> > Is this related to the standard ARM SCU that manages multiprocessor
>> > systems, or a different unit that uses the same name?
>>
>> FKAN: You mean the snoop control unit in ARM. This is different from
>> that, the main function of this unit is clk control.
>
> Hmm, if it's *mainly* used for clocks, you may actually just want to
> have a driver in drivers/clk for it that also performs a few of the
> other things on the side.
>

FKAN: there among other thing, reset controls, fuse id's and deep sleep
resume registers... I like your idea of using syscon, we can have a node
for SCU and then the specific driver to parse out the needed chunk to use.

>         Arnd
