Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161AbaDXNcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 09:32:24 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:60004 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826AbaDXNbV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 09:31:21 -0400
MIME-Version: 1.0
In-Reply-To: <2784123.GhF2tcctEM@vostro.rjw.lan>
References: <liocsk$le0$1@ger.gmane.org>
	<20140424052151.GA9449@sucs.org>
	<2784123.GhF2tcctEM@vostro.rjw.lan>
Date: Thu, 24 Apr 2014 16:31:19 +0300
Message-ID: <CAPWNY8X3fVAM3kcdWmg0BcQuNw84ROY+wQsh-JzfxGEt1uWFQQ@mail.gmail.com>
Subject: Re: [REGRESSION] Media keys cause "ACPI: \_SB_.ATKD: Unsupported
 event" on ASUS laptop
From: =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, Len Brown <lenb@kernel.org>,
        Robert Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 1:51 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Thursday, April 24, 2014 06:21:52 AM Sitsofe Wheeler wrote:
>> On Thu, Apr 17, 2014 at 02:11:15PM +0300, Mantas Mikulėnas wrote:
>> > After commit 1a699476e258 [two months ago], Linux has stopped
>> > recognizing the media & function keys on my laptop's keyboard (the
>> > laptop is ASUS K52JT.206).
>> >
>> > When I press any of the Fn keys (Play/Pause, Stop, Prev, Next, Vol+,
>> > Vol-, Mute, WiFi, Brightness +/-...), I get the following messages in dmesg:
>> >
>> > | ACPI: \_SB_.ATKD: Unsupported event type 0x45
>> > | ACPI: \_SB_.ATKD: Unsupported event type 0x43
>> > | ACPI: \_SB_.ATKD: Unsupported event type 0x40
>> > | etc.
>>
>> I'm seeing the same problem with an EeePC 900's volume and brightness
>> keys:
>> [ 90.098518] ACPI: \_SB_.ATKD: Unsupported event type 0x14
>> [   90.785202] ACPI: \_SB_.ATKD: Unsupported event type 0x15
>> [  457.062072] ACPI: \_SB_.ATKD: Unsupported event type 0x2e
>> [  457.926754] ACPI: \_SB_.ATKD: Unsupported event type 0x2d
>> [  458.418740] ACPI: \_SB_.ATKD: Unsupported event type 0x2c
>> [  458.821482] ACPI: \_SB_.ATKD: Unsupported event type 0x2b
>> [  459.240896] ACPI: \_SB_.ATKD: Unsupported event type 0x2a
>
> Does this patch help:
>
> ---
>  drivers/acpi/bus.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Yes, it seems to be working fine.


Thanks!

-- 
Mantas Mikulėnas <grawity@gmail.com>
