Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab3H1MWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 08:22:43 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:18825 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab3H1MWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 08:22:41 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-2d-521deb901d39
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Len Brown <lenb@kernel.org>, Andy Henroid <andrew.d.henroid@intel.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [RFC] removal of drivers/idle/ directory
Date: Wed, 28 Aug 2013 14:22:36 +0200
Message-id: <2998196.JgbABsZZJs@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t9jAd0Jr2WDDLr/iVrsON7PYrHz4Vs2
	i8u75rBZfO49wmjxY8NjVgdWj8V7XjJ5bFrVyebxeZNcAHMUl01Kak5mWWqRvl0CV8bUiZ2s
	BUtYKpb8E29gPMjcxcjJISFgIrGu+ymULSZx4d56ti5GLg4hgUWMEvuPzGGHcFqYJK5sOsoC
	UsUmYCUxsX0VI4gtIuAlcWXvErBuZiC7b/EyMFtYwFDi9d0fYDaLgKrE1VMbwWxeAU2J1zs3
	gc0RFfCU+DRpKVRcUOLH5HssEHPkJfbtn8oKYWtJrN95nGkCI98sJGWzkJTNQlK2gJF5FaNo
	akFyQXFSeq6RXnFibnFpXrpecn7uJkZwMD6T3sG4qsHiEKMAB6MSD6/FZpkgIdbEsuLK3EOM
	EhzMSiK8/Ntlg4R4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmy1DhQSSE8sSc1OTS1ILYLJMnFw
	SjUwqj34fyT37VNFYe2K7JsOe2/3XP2uWrc28kvH58XJexW2Lj0k4Lf/ZdeaOyuuzXuy/MF5
	NU/n2VtmejHmvNzDwHPPeh/Lp5/bDv//fW4lz7zsq0mHvBrlX13xWyyZ90Ekdtbf8qv/d/in
	+ntkpfc/jfqau3HHLM/VCzemdD2p+7CTb88NloVSKvVKLMUZiYZazEXFiQAKHdd1QgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

drivers/idle/ directory currently contains only two drivers:

* intel_idle which is a cpuidle driver for certain Intel processors

* i7300_idle which is a driver for certain Intel x86_64 servers
  (it provides idle memory power savings)

How's about moving intel_idle to drivers/cpuidle/ (where it should
belong as cpuidle driver) and i7300_idle to drivers/platform/x86/
(or eventually to a new directory named drivers/memidle/)?

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

