Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab3AREUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 23:20:50 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:43070 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754950Ab3AREUq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 23:20:46 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Subject: RE: [PATCH v2 2/2] pwm: pwm-tiecap: Low power sleep support
Thread-Topic: [PATCH v2 2/2] pwm: pwm-tiecap: Low power sleep support
Thread-Index: AQHN9JPIpbCL+2I5f0KG7KNZRmDEDphNUdYAgAEqvOA=
Date: Fri, 18 Jan 2013 04:19:39 +0000
Deferred-Delivery: Fri, 18 Jan 2013 04:19:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EA5F455@DBDE01.ent.ti.com>
References: <1358414403-13431-1-git-send-email-avinashphilip@ti.com>
 <1358414403-13431-3-git-send-email-avinashphilip@ti.com>
 <20130117155914.GB2186@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20130117155914.GB2186@avionic-0098.adnet.avionic-design.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 21:29:14, Thierry Reding wrote:
> On Thu, Jan 17, 2013 at 02:50:03PM +0530, Philip Avinash wrote:
> > In low power modes of AM33XX platforms, peripherals power is cut off.
> > This patch supports low power sleep transition support for ECAP driver.
> > 
> > Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> > ---
> > Changes since v1:
> > 	- check the enabled status of pwm device for handling module
> > 	  enable/disable on resume/suspend
> > 
> >  drivers/pwm/pwm-tiecap.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 53 insertions(+)
> 
> Applied, thanks.

Thanks for applying this patch
Avinash

> 
> Thierry
> 

