Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749AbaFLH4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 03:56:23 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:36866 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932501AbaFLH4W convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 03:56:22 -0400
From: Eyal Perry <eyalpe@mellanox.com>
To: Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Eyal Perry <eyalpe@mellanox.com>
Subject: RE: genirq: Provide !SMP stub for irq_set_affinity_notifier()
Thread-Topic: genirq: Provide !SMP stub for irq_set_affinity_notifier()
Thread-Index: AQHPhbQXZksbNoswiEGh1EEP7xfJ15ttG26w
Date: Thu, 12 Jun 2014 07:55:24 +0000
Message-ID: <79BE8FC19482BD4291F88BB24CD776FCD49B22AA@MTLDAG01.mtl.com>
References: <20140608185919.57FB46621E2@gitolite.kernel.org>
 <20140611203438.GA4035@kroah.com>
In-Reply-To: <20140611203438.GA4035@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.0.13.1]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

The commit I refer is now in the net-next tree, see there these two:

9e311e7 net/mlx4_en: Use affinity hint
da91309 cpumask: Utility function to set n'th cpu - local cpu first

As of other issues both were accepted and later reverted, but are now
back and will be pushed by Dave Miller for 3.16-rc1
