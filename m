Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746AbaFLIsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 04:48:10 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:60397 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932770AbaFLIsI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 04:48:08 -0400
From: Eyal Perry <eyalpe@mellanox.com>
To: Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Eyal Perry <eyalpe@mellanox.com>
Subject: RE: genirq: Provide !SMP stub for irq_set_affinity_notifier()
Thread-Topic: genirq: Provide !SMP stub for irq_set_affinity_notifier()
Thread-Index: AQHPhbQXZksbNoswiEGh1EEP7xfJ15ttG26wgAAOuxA=
Date: Thu, 12 Jun 2014 08:47:37 +0000
Message-ID: <79BE8FC19482BD4291F88BB24CD776FCD49B235B@MTLDAG01.mtl.com>
References: <20140608185919.57FB46621E2@gitolite.kernel.org>
 <20140611203438.GA4035@kroah.com>
 <79BE8FC19482BD4291F88BB24CD776FCD49B22AA@MTLDAG01.mtl.com>
In-Reply-To: <79BE8FC19482BD4291F88BB24CD776FCD49B22AA@MTLDAG01.mtl.com>
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

Greg,

Sorry, there was a little mess here,
I was wrongly referring to two other commits... so again --

The commit 2eacc23 ("net/mlx4_core: Enforce irq affinity changes immediately")
is present in Dave's net-next tree and will be pushed by Dave to Linus for
the 3.16 merge window

Hope this helps to clarify

Best Regards,
Eyal.
