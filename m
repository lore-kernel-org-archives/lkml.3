Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab3LaHoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 02:44:00 -0500
Received: from wapice.fi ([81.209.51.2]:33489 "EHLO brando.wapice.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751762Ab3LaHn7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 02:43:59 -0500
X-Greylist: delayed 454 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Dec 2013 02:43:59 EST
From: Jouko Haapaluoma <jouko.haapaluoma@wapice.com>
To: Nicholas Mc Guire <der.herr@hofr.at>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
CC: =?iso-8859-1?Q?Sami_Pietik=E4inen?= <Sami.Pietikainen@wapice.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Steven Rostedt" <rostedt@goodmis.org>
Subject: RE: [PATCH RT] add missing local serialization in ip_output.c
Thread-Topic: [PATCH RT] add missing local serialization in ip_output.c
Thread-Index: AQHPBLkUD/AMzKww4UeFf5n2t6hY7ppt5c1z
Date: Tue, 31 Dec 2013 07:36:20 +0000
Message-ID: <C9F8415089354E4FB76F4548B3515AF476ADD75F@edb1.wapice.localdomain>
References: <20131229171154.GA23586@opentech.at>
In-Reply-To: <20131229171154.GA23586@opentech.at>
Accept-Language: en-US, fi-FI
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.0.200]
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I confirm that this patch works. Tested it overnight with Zedboard (Cortex A9). Thanks again!

BR,
Jouko