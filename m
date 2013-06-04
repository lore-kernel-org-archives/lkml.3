Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab3FDJla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:41:30 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53432 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab3FDJl1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:41:27 -0400
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: Kevin Hilman <khilman@linaro.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "zonque@gmail.com" <zonque@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Bedia, Vaibhav" <vaibhav.bedia@ti.com>,
        "Rajashekhara, Sudhakar" <sudhakar.raj@ti.com>
Subject: RE: [PATCH 2/2] rtc: omap: add rtc wakeup support to alarm events
Thread-Topic: [PATCH 2/2] rtc: omap: add rtc wakeup support to alarm events
Thread-Index: AQHOXiYQaPj+OUHVHUilAFHAKAjcJ5klUjQg
Date: Tue, 4 Jun 2013 09:39:27 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EC222D4@DBDE04.ent.ti.com>
References: <1369982005-8572-1-git-send-email-gururaja.hebbar@ti.com>
	<1369982005-8572-3-git-send-email-gururaja.hebbar@ti.com>
 <87a9nb2gjh.fsf@linaro.org>
In-Reply-To: <87a9nb2gjh.fsf@linaro.org>
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

On Fri, May 31, 2013 at 23:11:22, Kevin Hilman wrote:
> Hebbar Gururaja <gururaja.hebbar@ti.com> writes:
> 
> > On some platforms (like AM33xx), a special register (RTC_IRQWAKEEN)
> > is available to enable Wakeup feature for Alarm Events.
> >
> > Since new platforms/Boards are now added through DT only, this feature
> > is supported via DT property only.
> 
> > Platforms using such IP should add the property "ti,has_irq_wake_enb"
> > in rtc DT node.
> 
> This is a property of the IP, not the board.  

Correct.

> Can't you detect this
> based on the revision of the IP?

Will check this and return.

> 
> Kevin
> 


Regards, 
Gururaja
