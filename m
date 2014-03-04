Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbaCDGq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 01:46:58 -0500
Received: from ni.piap.pl ([195.187.100.4]:43794 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbaCDGq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 01:46:57 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Anton Vorontsov <anton@enomsg.org>, Yinghai Lu <yinghai@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
References: <m3eh2nqz7n.fsf@t19.piap.pl> <m3sir3pk2a.fsf@t19.piap.pl>
	<7246660.Cp8cQBZRIp@wuerfel>
Date: Tue, 04 Mar 2014 07:46:55 +0100
In-Reply-To: <7246660.Cp8cQBZRIp@wuerfel> (Arnd Bergmann's message of "Fri, 28
	Feb 2014 12:15:54 +0100")
MIME-Version: 1.0
Message-ID: <m3zjl6o3z4.fsf@t19.piap.pl>
Content-Type: text/plain
Subject: Re: [PATCH] CNS3xxx: Fix PCIe early iotable_init().
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE,
	 bases: 20140303 #7388596, check: 20140304 clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> Patch looks good, but please add the changeset description from
> your first patch.

I wonder if another approach would be better. I don't like the .pfn
messing and the bugs that function introduces.
-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
