Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbaK0Piu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:38:50 -0500
Received: from mx0.aculab.com ([213.249.233.131]:43324 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750895AbaK0Pio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:38:44 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'David Hildenbrand'" <dahi@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christian Borntraeger" <borntraeger@de.ibm.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "mingo@kernel.org" <mingo@kernel.org>
Subject: RE: [RFC 0/2] Reenable might_sleep() checks for might_fault() when
 atomic
Thread-Topic: [RFC 0/2] Reenable might_sleep() checks for might_fault() when
 atomic
Thread-Index: AQHQClV0/jzAGGN4U0aVkHiOIDETdJx0mueg
Date: Thu, 27 Nov 2014 15:37:28 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1C9FDD6A@AcuExch.aculab.com>
References: <20141126151729.GB9612@redhat.com>
 <20141126152334.GA9648@redhat.com> <20141126163207.63810fcb@thinkpad-w530>
 <20141126154717.GB10568@redhat.com> <5475FAB1.1000802@de.ibm.com>
 <20141126163216.GB10850@redhat.com> <547604FC.4030300@de.ibm.com>
 <20141126170447.GC11202@redhat.com> <20141127070919.GA4390@osiris>
 <20141127090301.3ddc3077@thinkpad-w530> <20141127120441.GB4390@osiris>
 <alpine.DEB.2.11.1411271602320.3961@nanos>
 <20141127161905.7c6220ee@thinkpad-w530>
In-Reply-To: <20141127161905.7c6220ee@thinkpad-w530>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sARFcvUJ025686

From: David Hildenbrand
...
> Although it might not be optimal, but keeping a separate counter for
> pagefault_disable() as part of the preemption counter seems to be the only
> doable thing right now. I am not sure if a completely separated counter is even
> possible, increasing the size of thread_info.

What about adding (say) 0x10000 for the more restrictive test?

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
