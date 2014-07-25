Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760837AbaGYQnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:43:52 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:55807 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbaGYQnv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:43:51 -0400
MIME-Version: 1.0
In-Reply-To: <CABxcv=kP2PCcNCtM1WUXx5wGG4m-jdw-P1dw0boaSwdJpoX=jQ@mail.gmail.com>
References: <1405704009-8430-1-git-send-email-afaerber@suse.de>
	<1405704009-8430-4-git-send-email-afaerber@suse.de>
	<CABxcv=kP2PCcNCtM1WUXx5wGG4m-jdw-P1dw0boaSwdJpoX=jQ@mail.gmail.com>
Date: Fri, 25 Jul 2014 09:43:46 -0700
X-Google-Sender-Auth: HPxrbSs50VqXW2Pp62iw02dW_BU
Message-ID: <CAD=FV=V-7+Jj7b8-fQL1PiQhNmhiGOPJzitGd__OUQLDteO_8g@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] ARM: dts: exynos5250: Fold common ChromeOS parts
 into Snow
From: Doug Anderson <dianders@chromium.org>
To: Javier Martinez Canillas <javier@dowhile0.org>
Cc: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "moderated list:ARM/SAMSUNG ARM A..." 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javier,

On Fri, Jul 25, 2014 at 9:35 AM, Javier Martinez Canillas
<javier@dowhile0.org> wrote:
> Hello Andreas,
>
> On Fri, Jul 18, 2014 at 7:20 PM, Andreas Färber <afaerber@suse.de> wrote:
>>
>> +       memory {
>> +               reg = <0x40000000 0x80000000>;
>> +       };
>> +
>> +       chosen {
>> +       };
>> +
>
> Is there a reason for an empty chosen node? Same for the Spring DTS.

I know that the bootloader (U-Boot) fills this in.  I'd have to double
check how the bootloader handles the node not being there to begin
with.
