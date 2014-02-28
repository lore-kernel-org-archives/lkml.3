Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907AbaB1LQB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 06:16:01 -0500
Received: from moutng.kundenserver.de ([212.227.17.13]:56532 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaB1LQA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 06:16:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Krzysztof =?utf-8?B?SGHFgmFzYQ==?= <khalasa@piap.pl>,
        Russell King <linux@arm.linux.org.uk>,
        Anton Vorontsov <anton@enomsg.org>, Yinghai Lu <yinghai@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CNS3xxx: Fix PCIe early iotable_init().
Date: Fri, 28 Feb 2014 12:15:54 +0100
Message-ID: <7246660.Cp8cQBZRIp@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <m3sir3pk2a.fsf@t19.piap.pl>
References: <m3eh2nqz7n.fsf@t19.piap.pl> <m3sir3pk2a.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V02:K0:H8qYjP1U4zj81sv3G41veDjEeelvkZzMr4r9o0WWjSr
 7494QfIKQS+gh4X1/oOY0ZQNJybGYKd822X8hpHgaWtyV3/MS3
 mteSRbEXAC0Crcbaw4V7gbpXow7+4DqpKRpe3kEWpauD65mBwf
 UG06ex/T0G8KVAgAo3TCwV4LHZJ6VUpjjQt/3pURDCEKx05E6n
 AGNmGrSgDn+X/4E5VX7Gy110qpHSLeAzACfE7irllWsRL38C+a
 sh7BxXI18qwuSlla5TdA9XacwB914lwuyPa2I/aIbmmSFdVqT9
 3/p2/x8iWEZaGdef7rTjoVwkZy9dwZ5O8ktCXn6VZgW6y8xVzT
 kPMc0+9D+LZo9z5dOYJs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 February 2014 12:12:45 Krzysztof Hałasa wrote:
> Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>
> 

Patch looks good, but please add the changeset description from
your first patch.

	Arnd
