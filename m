Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab3A3MiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 07:38:12 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:38687 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359Ab3A3MiJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 07:38:09 -0500
From: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>,
        "N, Mugunthan V" <mugunthanvnm@ti.com>
CC: Richard Cochran <richardcochran@gmail.com>,
        "Porter, Matt" <mporter@ti.com>, "Maupin, Chase" <chase.maupin@ti.com>,
        "Kridner, Jason" <jdk@ti.com>, Tony Lindgren <tony@atomide.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] cpsw: Fix interrupt storm among other things
Thread-Topic: [PATCH] cpsw: Fix interrupt storm among other things
Thread-Index: AQHN/VkLC7cBWM1SeUOPLhpObgalgphf1VUAgAFdd4CAAAeFAIAACU4AgAAWMICAAAOoAIAAc54A
Date: Wed, 30 Jan 2013 12:38:02 +0000
Message-ID: <B5906170F1614E41A8A28DE3B8D121433ED03FE1@DBDE01.ent.ti.com>
References: <1359378668-26536-1-git-send-email-panto@antoniou-consulting.com>
 <5107B650.5090901@ti.com>
 <3DE2C638-6AE8-4BC9-AD68-3AAA40CD6233@antoniou-consulting.com>
 <5108E1C6.9020201@ti.com>
 <0FB10FF4-6639-472E-943C-61CEDB0336E0@antoniou-consulting.com>
 <5108FC31.3000507@ti.com>
 <27A3106E-3FDB-43DB-AAC9-DC2DA768AF9E@antoniou-consulting.com>
In-Reply-To: <27A3106E-3FDB-43DB-AAC9-DC2DA768AF9E@antoniou-consulting.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.133.119]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 16:38:50, Pantelis Antoniou wrote:
[...]
> 
> TBH I haven't found a simple way to print out the silicon revision number.
> Anyone on the list know a quick and dirty method? 
> 

You can dump the DEVICE_ID register @ 0x44e10600.
Bits 31:28 should be 0 for PG1.0 and 1 for PG2.0.

Regards,
Vaibhav 

