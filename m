Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab3EaGr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 02:47:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46702 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab3EaGrt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 02:47:49 -0400
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "zonque@gmail.com" <zonque@gmail.com>,
        "rob@landley.net" <rob@landley.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 1/2] rtc: omap: add option to indicate wakeup support
 through DT
Thread-Topic: [PATCH 1/2] rtc: omap: add option to indicate wakeup support
 through DT
Thread-Index: AQHOXch/BNPfWUFEYEK7eB5cu8HcGZkeUv0AgACGb6A=
Date: Fri, 31 May 2013 06:46:42 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EC1E168@DBDE04.ent.ti.com>
References: <1369982005-8572-1-git-send-email-gururaja.hebbar@ti.com>
 <1369982005-8572-2-git-send-email-gururaja.hebbar@ti.com>
 <CA+V-a8vAM_4qC20Fpipu3tROs65dERoFgV-ypyJh336rir-0EQ@mail.gmail.com>
In-Reply-To: <CA+V-a8vAM_4qC20Fpipu3tROs65dERoFgV-ypyJh336rir-0EQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 12:14:44, Prabhakar Lad wrote:
> Hi Gururaja,
> 
> Thanks for the patch.
> 
> On Fri, May 31, 2013 at 12:03 PM, Hebbar Gururaja
> <gururaja.hebbar@ti.com> wrote:
> > Even though RTC-IP is wakeup capable, Not all Boards support it.
> >
> > For example
> > The rtc alarm wakeup is available in rtc-ip since omap1 days but alarm
> > was not wired properly in previous ompa1 boards.
> >
> [snip]
> >
> > +Optional properties:
> > +- ti,wakeup_capable: Inform the rtc driver that this module is wake-up
> For devicetree properties '-' is preferred over '_'.

Thanks for the review. I will make the correction. But will wait for some 
more time (so others can review) and then send V2

> 
> Regards,
> --Prabhakar Lad
> 


Regards, 
Gururaja
