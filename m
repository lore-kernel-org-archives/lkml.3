Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbaBXDlb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 22:41:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:36470 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbaBXDl2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 22:41:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,532,1389772800"; 
   d="scan'208";a="460723206"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: "gleb@redhat.com" <gleb@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Subject: RE: [PATCH v4 3/3] KVM: x86: Enable Intel MPX for guest
Thread-Topic: [PATCH v4 3/3] KVM: x86: Enable Intel MPX for guest
Thread-Index: AQHPLy/Hffa0mA48RJ+9cL55JkIR25rDxXfw
Date: Mon, 24 Feb 2014 03:40:15 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923350150D295@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC829233501509C2B@SHSMSX101.ccr.corp.intel.com>
 <530795E0.7080602@redhat.com>
In-Reply-To: <530795E0.7080602@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini wrote:
> Il 21/02/2014 18:57, Liu, Jinsong ha scritto:
>> -		F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | F(RDSEED) |
>> +		F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | F(MPX) | F(RDSEED) |
>>  		F(ADX);
> 
> MPX also needs to be conditional on mpx_supported here, like it is
> done with f_rdtscp for example.
> 
> Paolo

Yes, has updated and sent out.

Thanks,
Jinsong