Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbaAHHT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 02:19:27 -0500
Received: from wapice.fi ([81.209.51.2]:58321 "EHLO brando.wapice.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751472AbaAHHTU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 02:19:20 -0500
X-Greylist: delayed 491 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Jan 2014 02:19:20 EST
From: =?iso-8859-1?Q?Sami_Pietik=E4inen?= <Sami.Pietikainen@wapice.com>
To: Jouko Haapaluoma <jouko.haapaluoma@wapice.com>,
        Nicholas Mc Guire <der.herr@hofr.at>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Steven Rostedt" <rostedt@goodmis.org>
Subject: RE: [PATCH RT] add missing local serialization in ip_output.c
Thread-Topic: [PATCH RT] add missing local serialization in ip_output.c
Thread-Index: AQHPBLkUvIuPqS7Tb0mLHSi7YgZgLpptywUAgAyql3A=
Date: Wed, 8 Jan 2014 07:11:08 +0000
Message-ID: <EBD2DE4ADA47B94E831AED12A4B0CADA844B1E58@edb0.wapice.localdomain>
References: <20131229171154.GA23586@opentech.at>
 <C9F8415089354E4FB76F4548B3515AF476ADD75F@edb1.wapice.localdomain>
In-Reply-To: <C9F8415089354E4FB76F4548B3515AF476ADD75F@edb1.wapice.localdomain>
Accept-Language: fi-FI, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.0.0.93]
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Patch also tested overnight with the Atmel SAMA5D35 evaluation board using
the same setup that originally produced the oops. No problems whatsoever.

BR,
Sami
