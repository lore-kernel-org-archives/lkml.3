Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbaCDJM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 04:12:28 -0500
Received: from ni.piap.pl ([195.187.100.4]:49082 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756686AbaCDJI7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:08:59 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: linux-arm-kernel@lists.infradead.org
Cc: lkml <linux-kernel@vger.kernel.org>, Anton Vorontsov <anton@enomsg.org>,
        Yinghai Lu <yinghai@kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
References: <m3eh2nqz7n.fsf@t19.piap.pl> <m3r46io1nd.fsf@t19.piap.pl>
Date: Tue, 04 Mar 2014 10:08:56 +0100
In-Reply-To: <m3r46io1nd.fsf@t19.piap.pl> ("Krzysztof =?utf-8?Q?Ha=C5=82as?=
 =?utf-8?Q?a=22's?= message of
	"Tue, 04 Mar 2014 08:37:10 +0100")
MIME-Version: 1.0
Message-ID: <m3eh2inxef.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [PATCH v2] CNS3xxx: Fix PCIe early iotable_init().
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE,
	 bases: 20140303 #7388596, check: 20140304 clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

khalasa@piap.pl (Krzysztof Hałasa) writes:

> This patch fixes the following BUG:
>
>> kernel BUG at mm/vmalloc.c:1132!
>> PC is at vm_area_add_early+0x20/0x84
>> LR is at add_static_vm_early+0xc/0x60
>>
>> The problem is cns3xxx_pcie_init() (device_initcall) calls the "early"
>> iotable_init().

That's obviously:

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
