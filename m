Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735Ab3HUJIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 05:08:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36631 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552Ab3HUJIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 05:08:39 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <BEC9F67575FA1E429CA7CF5AE9BE3634012ED68C@SHSMSX104.ccr.corp.intel.com>
References: <1377049949.18357.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC> <20130821072940.GB27495@gmail.com> <69b80c44-3245-4393-b6e9-4d8a7f3d3c66@email.android.com> <BEC9F67575FA1E429CA7CF5AE9BE3634012ED68C@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: RE: [PATCH] reboot: perform warm/cold reset correctly for CF9 type
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 21 Aug 2013 11:07:48 +0200
To: "Li, Fei" <fei.li@intel.com>, Ingo Molnar <mingo@kernel.org>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "holt@sgi.com" <holt@sgi.com>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <7233d29e-ea01-4eb6-8018-b9c8e3730a30@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The thing is that the existing "warm" and "cold" means something different, I believe (skip post vs do post.)  It is possible it just works, but it would be good to know which platforms or works on.

Also, why do you need the cf9 boot method at all?  All current systems * should * use the ACPI method.

"Li, Fei" <fei.li@intel.com> wrote:
>> Careful.  This is a very different definition of warm vs cold boot
>used elsewhere.
>
>We have tested both warm and cold reboot on our x86 platform, and it
>works well.
>Besides with commit, the expected warm and reboot type can be specified
>through
>command line.
>
>> >Looks good, but please introduce a reboot_val intermediate
>> >variable instead of duplicating that ugly line-broken
>> >construct twice.
>
>Accepted and will update it in later version. 
>
>> >
>> >Thanks,
>> >
>> >	Ingo
>> 
>
>Thanks,
>Fei

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
