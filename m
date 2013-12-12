Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546Ab3LLLJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 06:09:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:28202 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429Ab3LLLJb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 06:09:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,877,1378882800"; 
   d="scan'208";a="423507512"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: "gleb@redhat.com" <gleb@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ren, Qiaowei" <qiaowei.ren@intel.com>
Subject: RE: [PATCH v2 0/4] X86/KVM: enable Intel MPX for KVM
Thread-Topic: [PATCH v2 0/4] X86/KVM: enable Intel MPX for KVM
Thread-Index: AQHO9x6gf+S7r+6fxkeY+guSVvGgeppQZqDA
Date: Thu, 12 Dec 2013 11:09:29 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC829233501422743@SHSMSX101.ccr.corp.intel.com>
References: <1386394315-48984-1-git-send-email-jinsong.liu@intel.com>
 <DE8DF0795D48FD4CA783C40EC82923350141B4A7@SHSMSX101.ccr.corp.intel.com>
 <52A83606.40908@redhat.com>
 <DE8DF0795D48FD4CA783C40EC829233501421D73@SHSMSX101.ccr.corp.intel.com>
 <52A98548.9010008@redhat.com>
In-Reply-To: <52A98548.9010008@redhat.com>
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
> Il 12/12/2013 06:47, Liu, Jinsong ha scritto:
>> Paolo Bonzini wrote:
>>> Il 11/12/2013 09:31, Liu, Jinsong ha scritto:
>>>> Paolo, comments for version 2?
>>> 
>>> I think I commented that it's fine, I'm just waiting for a rebase
>>> on top of the generic patches. 
>>> 
>>> Paolo
>>> 
>> 
>> Thanks! common MPX definiation patches have been checked in tip tree
>> (both Qiaowei and I use that definiations):
>> http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?id=191f57c137bcce0e3e9313acb77b2f114d15afbb
>> http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?id=e7d820a5e549b3eb6c3f9467507566565646a669
> 
> Ok, can you rebase and resend?
> 
> Paolo

Sure, I have pulled and rebased on git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
No confliction, patches v3 will send out later.

Thanks,
Jinsong