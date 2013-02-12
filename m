Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759937Ab3BLVTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:19:15 -0500
Received: from mga11.intel.com ([192.55.52.93]:2045 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756707Ab3BLVTL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 16:19:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,652,1355126400"; 
   d="scan'208";a="286354262"
From: "Luck, Tony" <tony.luck@intel.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
CC: "Matt Fleming (matt@console-pimps.org)" <matt@console-pimps.org>,
        "mikew@google.com" <mikew@google.com>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [PATCH v6 -next 0/2] make efivars/efi_pstore interrupt-safe
Thread-Topic: [PATCH v6 -next 0/2] make efivars/efi_pstore interrupt-safe
Thread-Index: Ac4IgIcxM7O3s+EQSmu/fWeiIUzHoAA5a8wg
Date: Tue, 12 Feb 2013 21:19:08 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1E059E92@ORSMSX107.amr.corp.intel.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A91283@USINDEM103.corp.hds.com>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D414A91283@USINDEM103.corp.hds.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Changelog
> v5 -> v6
>   - Rebase to a latest linux-next tree.
>   - Modify a comment from "efivar_update_sysfs_entry" to 
>     "efivar_update_sysfs_entries" in include/linux/efi.h (Patch 2/2)

Applied to my internal pstore topic branch - which feeds to linux-next. Note
that my branch was based on 3.8-rc2 so I unwound the changes to match
up with Linus latest.  Hope I didn't break anything in the process.

-Tony
