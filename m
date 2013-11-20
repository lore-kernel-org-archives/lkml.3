Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab3KTP7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 10:59:49 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:54611 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab3KTP7o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 10:59:44 -0500
MIME-Version: 1.0
In-Reply-To: <201311201550.05800@pali>
References: <201309151553.34000@pali>
	<201311141302.33384@pali>
	<20131119212736.GA25784@core.coreip.homeip.net>
	<201311201550.05800@pali>
Date: Wed, 20 Nov 2013 10:59:42 -0500
Message-ID: <CAN+gG=HwuES-H4y5=_VcEQg4OiE2NYmra2+MzsbPusiOEq7Qsw@mail.gmail.com>
Subject: Re: input question: ambient light sensor button
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Nov 20, 2013 at 9:50 AM, Pali Rohár <pali.rohar@gmail.com> wrote:
>> > > I guess we need patch adding
>> > >
>> > >   #define KEY_ALS_TOGGLE  0x230
>> > >
>> > > Thanks.
>> >
>> > So there is no good key for als yet?
>>
>> No, but if you send me a patch adding it I will gladly apply
>> it.
>>
>> Thanks.
>
> Ok, here is patch:
>
> Add key code for ambient light sensor button
>
> More notebooks have special button for enabling/disabling ambient
> light sensor. This patch adding new als code to input.h header file.
>
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
>
> diff --git a/include/uapi/linux/input.h b/include/uapi/linux/input.h
> index a372627..1562f10 100644
> --- a/include/uapi/linux/input.h
> +++ b/include/uapi/linux/input.h
> @@ -719,6 +719,8 @@ struct input_keymap_entry {
>  #define BTN_DPAD_LEFT          0x222
>  #define BTN_DPAD_RIGHT         0x223
>
> +#define KEY_ALS_TOGGLE         0x230

Could you just add a comment explaining that ALS is ambiant light
sensor? Otherwise, I'm sure someone else will use this event code for
an other thing... :)

Cheers,
Benjamin
