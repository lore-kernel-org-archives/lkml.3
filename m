Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab3F1Kpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:45:30 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:51507 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755402Ab3F1Kp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:45:29 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1306271147150.3538@pobox.suse.cz>
References: <1371303165-1802-1-git-send-email-dh.herrmann@gmail.com>
	<1371303165-1802-2-git-send-email-dh.herrmann@gmail.com>
	<20130626160727.GA32420@core.coreip.homeip.net>
	<alpine.LNX.2.00.1306271147150.3538@pobox.suse.cz>
Date: Fri, 28 Jun 2013 12:45:27 +0200
Message-ID: <CANq1E4ROdBwtjKOwid=zOTvTDcLaM7wn1a2ck251vEBcFAEDSw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] input: document gamepad API and add extra keycodes
From: David Herrmann <dh.herrmann@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Todd Showalter <todd@electronjump.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Jun 27, 2013 at 11:47 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 26 Jun 2013, Dmitry Torokhov wrote:
>
>> On Sat, Jun 15, 2013 at 03:32:44PM +0200, David Herrmann wrote:
>> > --- a/include/uapi/linux/input.h
>> > +++ b/include/uapi/linux/input.h
>> > @@ -507,10 +507,14 @@ struct input_keymap_entry {
>> >
>> >  #define BTN_GAMEPAD                0x130
>> >  #define BTN_A                      0x130
>> > +#define BTN_SOUTH          0x130
>>
>> Could we do:
>>
>> #define BTN_SOUTH             0x130
>> #define BTN_A                 BTN_SOUTH
>>
>> so that it is clear that BTN_A, BTN_B, etc are legacy definitions and
>> not an accidental typos that need their own key codes.
>
> Makes sense, will do that modification.
>
>> Otherwise:
>>
>> Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>
> Thanks Dmitry. Will be taking it (with the above modification) through my
> tree.

Thanks to both of you! Looks good.

Cheers
David
