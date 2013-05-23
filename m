Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758996Ab3EWVBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 17:01:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:47576 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758301Ab3EWVBY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 17:01:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,730,1363158000"; 
   d="scan'208";a="318605195"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Jacob Shin <jacob.shin@amd.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Ingo Molnar" <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>
CC: Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2 0/3] x86/microcode: early microcode patch loading
 support on AMD
Thread-Topic: [PATCH V2 0/3] x86/microcode: early microcode patch loading
 support on AMD
Thread-Index: AQHOV8vhQP241rPP7kqAkZJ623rTbZkTQGTQ
Date: Thu, 23 May 2013 21:01:21 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C712205633D6C3@ORSMSX106.amr.corp.intel.com>
References: <1369323618-5820-1-git-send-email-jacob.shin@amd.com>
In-Reply-To: <1369323618-5820-1-git-send-email-jacob.shin@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Jacob Shin [mailto:jacob.shin@amd.com]
> The following patchset adds early microcode patch loading support on
> AMD systems, on top of the framework introduced by:
>   https://lkml.org/lkml/2012/12/21/193
> 

Could you please change Documentation/x86/early-microcode.txt for AMD? At least please add AMD microcode file in cpio name space: kernel/x86/microcode/AuthenticAMD.bin. Users can generate the cpio file with AMD microcode based on your document.

Thanks.

-Fenghua

 
