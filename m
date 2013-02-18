Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab3BROao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 09:30:44 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:39497 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab3BROam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 09:30:42 -0500
MIME-Version: 1.0
In-Reply-To: <511CAD5D.2050502@ti.com>
References: <1360338220-12753-1-git-send-email-ruslan.bilovol@ti.com>
	<511B4C60.50404@ti.com>
	<CAB=otbSX_O-zbHZuPWPSEU0D1s3uKfZfeatoguoRiwogS5tVHQ@mail.gmail.com>
	<511CAD5D.2050502@ti.com>
Date: Mon, 18 Feb 2013 16:30:41 +0200
X-Google-Sender-Auth: j37ogFyhj3OVyVEYiSa7Zi2gMJg
Message-ID: <CAB=otbRAj41dFMe_i+LDGbi29kMV0C-tw-HXyz7iF4m4R+5R+Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/1] OMAP4: DSS: Add panel for Blaze Tablet boards
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: andi@etezian.org, FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

On Thu, Feb 14, 2013 at 11:24 AM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> On 2013-02-14 02:07, Ruslan Bilovol wrote:
>
>> This patch is exactly a part of mainlining of the BlazeTablet board support :)
>> The goal is to have as much as possible support of this board in the
>> 'vanilla' kernel.
>> The BlazeTablet mainlining is already ongoing (
>> https://patchwork.kernel.org/patch/2118281/ )
>> and I hope we will have some support of this board in near future.
>> The BlazeTablet's LCD panel support is very important thing for us to
>> have it in mainline because
>> without it the BlazeTablet becomes a 'black brick' and it is painful
>> for us to port this
>> driver against each new version of kernel.
>
> Ok, good to hear you're pushing it to mainline. However, you should
> mentally prepare for it being a black brick =(.
>
> Tony said he's not adding new board files, only DT from now on. The
> display subsystem driver and the panel drivers do not work with DT yet,
> and it will still take some time for that to realize.
>
> Thus adding this driver would help nothing, as it couldn't be used. And
> after the DSS and the panel drivers are made to work with DT (which is a
> big job, needing large rewrites of the drivers), there's a rework that
> has to be done with this driver to make it compatible with the new DSS
> model.
>
> So, I'm still inclined to say that we shouldn't merge this.

Thanks for explanation.

Do you have some plan when DSS will be ready to port this driver?
(3.10, 3.11 or later)?

Best regards,
Ruslan

>
>  Tomi
>
>
