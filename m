Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934424Ab3BTJ3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 04:29:22 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:40493 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934129Ab3BTJ3U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 04:29:20 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
CC: Bryan Wu <cooloney@gmail.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jeong, Daniel" <Daniel.Jeong@ti.com>
Subject: RE: [PATCH 1/3] leds: move LED trigger drivers into new subdirectory
Thread-Topic: [PATCH 1/3] leds: move LED trigger drivers into new
 subdirectory
Thread-Index: Ac4PRU+FwguO6PS/RFuCVzNMyCwQbP//gqiA//90NKA=
Date: Wed, 20 Feb 2013 09:29:15 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F792736C4@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F7927366E@DQHE02.ent.ti.com>
 <20130220090723.GA8049@balto.lan>
In-Reply-To: <20130220090723.GA8049@balto.lan>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For this kind of patches you should really use the "-M" flag of "git
> format-patch" to activate rename detection.  The patch becomes much
> more
> readable.  For example, the diffstat for this one using -M is:

Thanks for useful tip!

Regards,
Milo
