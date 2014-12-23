Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbaLWArA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 19:47:00 -0500
Received: from mga03.intel.com ([134.134.136.65]:56668 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421AbaLWAqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 19:46:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,627,1413270000"; 
   d="scan'208";a="641667695"
From: "Zhang, Yang Z" <yang.z.zhang@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
        "yong.y.wang@linux.intel.com" <yong.y.wang@linux.intel.com>
CC: "Wu, Feng" <feng.wu@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "gleb@kernel.org" <gleb@kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jiang.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" 
	<jiang.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "eric.auger@linaro.org" <eric.auger@linaro.org>
Subject: RE: [v3 13/26] KVM: Define a new interface kvm_find_dest_vcpu() for
 VT-d PI
Thread-Topic: [v3 13/26] KVM: Define a new interface kvm_find_dest_vcpu()
 for VT-d PI
Thread-Index: AdAeSev6JAZ1DRo1S4ebIhUdqD2+fg==
Date: Tue, 23 Dec 2014 00:46:44 +0000
Message-ID: <A9667DDFB95DB7438FA9D7D576C3D87E0AC06468@SHSMSX104.ccr.corp.intel.com>
References: <1415059685.1337085.1419266271242.JavaMail.zimbra@zmail13.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1415059685.1337085.1419266271242.JavaMail.zimbra@zmail13.collab.prod.int.phx2.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBN0lH50000505

Paolo Bonzini wrote on 2014-12-23:
>> The problem is we still need to support PI with lowest priority
>> delivery mode
> even if guest does not configure irq affinity via /proc/irq/. Don't we?
> 
> Yes, but we can get the basic support working first.
> 
> I and Feng talked on irc and agreed to start with a simple
> implementation. Then he can add support for vector hashing for all
> interrupts, both vt-d pi and normal LAPIC interrupts.

Agree. Obviously, current PI has some limitations to achieve highest performance. We can start with a simple implementation but must ensure we don't change hardware's behavior(From guest's point). Feng's current implementation or use the way I suggested are both ok since both of them cannot solve the problem well.

> 
> Paolo
>


Best regards,
Yang


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
