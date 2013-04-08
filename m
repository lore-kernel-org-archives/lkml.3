Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934776Ab3DHF6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 01:58:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52162 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263Ab3DHF6H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 01:58:07 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>
CC: "Nori, Sekhar" <nsekhar@ti.com>, "jacmet@sunsite.dk" <jacmet@sunsite.dk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>
Subject: RE: [PATCH 0/2] Update device tree binding document for
 pwm-tiehrpwm & pwm-tiecap
Thread-Topic: [PATCH 0/2] Update device tree binding document for
 pwm-tiehrpwm & pwm-tiecap
Thread-Index: AQHOKSb0dRKTq/znyk6o7Q0/0ZuchpjL6DsQ
Date: Mon, 8 Apr 2013 05:56:39 +0000
Deferred-Delivery: Mon, 8 Apr 2013 05:56:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EAA8DDE@DBDE01.ent.ti.com>
References: <1364195093-1357-1-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1364195093-1357-1-git-send-email-avinashphilip@ti.com>
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

Thierry,

On Mon, Mar 25, 2013 at 12:34:51, Philip, Avinash wrote:
> Update device tree document of pwm-tiehrpwm & pwm-tiecap in order to reflect the
> usage of similar modules in both da850 and am33xx platforms.

Can you accept both documentation update patches with Peter Korsgaard's Ack.

Thanks
Avinash
> 
> Philip Avinash (2):
>   pwm: pwm-tiecap: Update device-tree binding document
>   pwm: pwm-tiehrpwm: Update device-tree binding document
> 
>  .../devicetree/bindings/pwm/pwm-tiecap.txt         |   12 ++++++++++--
>  .../devicetree/bindings/pwm/pwm-tiehrpwm.txt       |   12 ++++++++++--
>  2 files changed, 20 insertions(+), 4 deletions(-)
> 
> -- 
> 1.7.9.5
> 
> 

