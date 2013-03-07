Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab3CGINg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 03:13:36 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:54700 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab3CGINe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 03:13:34 -0500
MIME-Version: 1.0
In-Reply-To: <51379849.6040903@infradead.org>
References: <20130306115052.2b1969acb7b7a0fa35975984@canb.auug.org.au>
	<51379849.6040903@infradead.org>
Date: Thu, 7 Mar 2013 09:13:32 +0100
Message-ID: <CAN+gG=H4_1nUhhsUe031Q1QrnVna+F7hmAepe6kbNm=8z_gOjw@mail.gmail.com>
Subject: Re: linux-next: Tree for Mar 6 (hid)
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Wed, Mar 6, 2013 at 8:26 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 03/05/13 16:50, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20130305:
>>
>
> on i386 and x86_64:
>

Sorry, it looks like my patches went not very smoothly.

> ERROR: "usb_control_msg" [drivers/hid/hid-multitouch.ko] undefined!

I've submitted a new patch removing this direct call. Maybe we should
change the Kconfig while these patches are not applied. Jiri?

> ERROR: "usb_ifnum_to_if" [drivers/hid/hid-holtek-kbd.ko] undefined!

oops, I'll have to double check this one.

>
> when CONFIG_USB_SUPPORT is not enabled.
>
> Should these drivers depend on USB_HID?

The goal of the patch series that breaks this was to make the hid
drivers independent of their transport layers, thus most of them
should not depend on usbhid anymore.

Cheers,
Benjamin

>
>
> --
> ~Randy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
