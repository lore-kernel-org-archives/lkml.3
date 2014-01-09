Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbaAIWvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 17:51:22 -0500
Received: from exprod5og111.obsmtp.com ([64.18.0.22]:60842 "HELO
	exprod5og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751330AbaAIWvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 17:51:20 -0500
MIME-Version: 1.0
In-Reply-To: <6073715.cGydpIHKD1@wuerfel>
References: <1389135041-16062-1-git-send-email-fkan@apm.com>
	<1389135041-16062-2-git-send-email-fkan@apm.com>
	<20140108100549.GE6701@e106331-lin.cambridge.arm.com>
	<6073715.cGydpIHKD1@wuerfel>
Date: Thu, 9 Jan 2014 14:51:19 -0800
Message-ID: <CAL85gmA5Ob+kp-+5seO-wcB8tx4jyiOeFMyCsZWFBLdX09nZDg@mail.gmail.com>
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

On Wed, Jan 8, 2014 at 2:08 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 08 January 2014 10:05:50 Mark Rutland wrote:
>> > +
>> > +Example:
>> > +
>> > +     reboot@0 {
>> > +             compatible = "apm,xgene-reboot";
>> > +             reg = <0x0 0x17000014 0x0 0x4>;
>> > +     };
>>
>> Given this seems to be a 64-bit address, the unit address should
>> preferably be 0,17000014 rather than just 0.
>
> I also wonder about the size and location of the register.
> Are you sure the device is just a single 4-byte register at offset
> 0x14, rather than a complex device that happens to contain the
> reset register?

FKAN: this is a single 4 byte register when clicked perform the system
reset of the platform.

>
>         Arnd
