Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007Ab3EORen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 13:34:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:40123 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759819Ab3EORel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 13:34:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,678,1363158000"; 
   d="scan'208";a="334559624"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: Victor Miasnikov <vvm@tut.by>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "\"Andy Whitcroft\"" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "JBeulich@suse.com" <JBeulich@suse.com>, Michal Hocko <mhocko@suse.cz>
Subject: RE: CONFIG_HYPERVISOR_GUEST=y   {-- replace --
 CONFIG_PARAVIRT_GUEST=y {= { # CONFIG_HYPERVISOR_GUEST is not set } Re:
 3.10-rc1 Fw: [PATCH 2/2] x86: Make Linux guest support optional
Thread-Topic: CONFIG_HYPERVISOR_GUEST=y   {-- replace --
 CONFIG_PARAVIRT_GUEST=y {= { # CONFIG_HYPERVISOR_GUEST is not set } Re:
 3.10-rc1 Fw: [PATCH 2/2] x86: Make Linux guest support optional
Thread-Index: AQHOUXeDzMj8lLRkj0mQN+psRz++UZkGgMLg
Date: Wed, 15 May 2013 17:34:10 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F2DA5ADDD@ORSMSX106.amr.corp.intel.com>
References: <20130514160108.GA5055@dhcp22.suse.cz>
 <925E2E537ECB4D0C8EA18467A4D20174@local.st.by>
 <20130515133405.GC5455@dhcp22.suse.cz>
 <293D65E8F6CE48768FF47E438C57ECD2@local.st.by>
 <20130515134656.GF5455@dhcp22.suse.cz>
 <FC7F5007EF934194A48587DB6A0DBCC0@local.st.by>
 <20130515142126.GA11783@pd.tnic>
In-Reply-To: <20130515142126.GA11783@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4FHYoEM016841

> Tony, what's your take on this - CONFIG_PARAVIRT_GUEST is
> present in ia64 and I recently changed the Kconfig symbol to
> CONFIG_HYPERVISOR_GUEST on x86. I can fix it for correctness but is
> hyperv and vmware balloon even attempted on ia64?
>
> Btw, it depends on BROKEN on ia64 so I'm already sceptical.

We added "BROKEN" in the middle of last year because this was
kicking out too many errors in Fengguang's zero-day build system.
Essentially all this stuff has been unmaintained for a while now,
and it doesn't seem that anyone is going to start caring about it
again.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
