Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759194AbaCTPP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:15:28 -0400
Received: from mail-yk0-f170.google.com ([209.85.160.170]:39879 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757056AbaCTPP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:15:26 -0400
MIME-Version: 1.0
In-Reply-To: <20140320155935.7a474173@armhf>
References: <20140320092639.48F68A6279@smtp3-g21.free.fr>
	<532ADFD8.80301@gmail.com>
	<20140320140156.5d768b1f@armhf>
	<532AEDE2.3080306@gmail.com>
	<20140320145221.09252bf6@armhf>
	<20140320143110.GU7528@n2100.arm.linux.org.uk>
	<20140320155935.7a474173@armhf>
Date: Thu, 20 Mar 2014 10:15:25 -0500
Message-ID: <CAOCHtYjtOdAMwjmC8_1Mm2jqHK3ah3Ra3j0+xxesy0VYkYB7OQ@mail.gmail.com>
Subject: Re: [PATCH] ASoC: tda998x: Fix lack of required reg in DT documentation
From: Robert Nelson <robertcnelson@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree <devicetree@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        dri-devel@lists.freedesktop.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 9:59 AM, Jean-Francois Moine <moinejf@free.fr> wrote:
> On Thu, 20 Mar 2014 14:31:10 +0000
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
>
>> 1. change the DT compatible strings the driver has to accept both
>>    nxp,tda19988 and nxp,tda19989, and set the appropriate device
>>    in the DT file (tda19988).  I'm a bit nervous about using
>>    "nxp,tda1998x" in case we're clashing with devices with different
>>    characteristics.
>
> The Cubox is sold with either the TDA19988 or the TDA19989 (I don't
> know about the AMX33XX boards). Then, setting the exact type in the DT
> would ask for 2 differents DTs or for having two tda998x definitions in
> a same DT...

fyi:

On the AM335x (BeagleBone Black), the NXP's chip ink shows, 88BHN so TDA19988

Regards,

-- 
Robert Nelson
http://www.rcn-ee.com/
