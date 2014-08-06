Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbaHFUiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 16:38:14 -0400
Received: from g6t1524.atlanta.hp.com ([15.193.200.67]:31937 "EHLO
	g6t1524.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbaHFUiN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 16:38:13 -0400
From: "Bueso, Davidlohr" <davidlohr@hp.com>
To: Guenter Roeck <linux@roeck-us.net>, David Howells <dhowells@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: FRV build failure with latest kernel
Thread-Topic: FRV build failure with latest kernel
Thread-Index: AQHPsX65xbpVRXHRm0qUv2a0mgA+1JvECSH1
Date: Wed, 6 Aug 2014 20:37:14 +0000
Message-ID: <279688AD5644A043870AAB6DBEFA9ED228280EE8@G5W2714.americas.hpqcorp.net>
References: <53E234DC.3050409@roeck-us.net>
In-Reply-To: <53E234DC.3050409@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.205.8.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


________________________________________
From: Guenter Roeck [linux@roeck-us.net]
Sent: Wednesday, August 06, 2014 6:59 AM
To: David Howells
Cc: linux-kernel@vger.kernel.org; Bueso, Davidlohr
Subject: FRV build failure with latest kernel

Building frv:defconfig ... failed
--------------
Error log:
In file included from kernel/locking/mutex.c:28:0:
kernel/locking/mcs_spinlock.h: In function 'mcs_spin_lock':
kernel/locking/mcs_spinlock.h:87:2: error: implicit declaration of function 'cpu_relax_lowlatency' [-Werror=implicit-function-declaration]https://lkml.org/lkml/2014/8/5/442
cc1: some warnings being treated as errors
make[2]: *** [kernel/locking/mutex.o] Error 1

Due to commit 3a6bfbc91d (arch, locking: Ciao arch_mutex_cpu_relax()), which missed frv.

Yeah, I sent out the fix yesterday: https://lkml.org/lkml/2014/8/5/442


(excuse my email formatting)