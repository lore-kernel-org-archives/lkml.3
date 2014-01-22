Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638AbaAVF3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 00:29:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:17056 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbaAVF3q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 00:29:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,697,1384329600"; 
   d="scan'208";a="442686754"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: "gleb@redhat.com" <gleb@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Ren, Qiaowei" <qiaowei.ren@intel.com>
Subject: [PATCH v3 0/4] X86/KVM: enable Intel MPX for KVM
Thread-Topic: [PATCH v3 0/4] X86/KVM: enable Intel MPX for KVM
Thread-Index: Ac8XMvAkgNcj7xrqSFGTgGO4UCA/wg==
Date: Wed, 22 Jan 2014 05:29:39 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923350149FC1E@SHSMSX101.ccr.corp.intel.com>
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

These patches are version 3 to enalbe Intel MPX for KVM.

Version 1:
  * Add some Intel MPX definiation
  * Fix a cpuid(0x0d, 0) exposing bug, dynamic per XCR0 features enable/disable 
  * vmx and msr handle for MPX support at KVM
  * enalbe MPX feature for guest

Version 2:
  * remove generic MPX definiation, Qiaowei's patch has add the definiation at kernel side
  * add MSR_IA32_BNDCFGS to msrs_to_save

Version 3:
  * rebase on latest kernel, which include Qiaowei's MPX common definiation pulled from HPA's tree

Thanks,
Jinsong