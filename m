Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbaKHKTm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 05:19:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:50175 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478AbaKHKTk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 05:19:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="485644598"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "sre@kernel.org" <sre@kernel.org>,
        "dbaryshkov@gmail.com" <dbaryshkov@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "anton@enomsg.org" <anton@enomsg.org>, "pavel@ucw.cz" <pavel@ucw.cz>
Subject: RE: [PATCH 1/3] power: core: Add generic interface to get battery
 specification.
Thread-Topic: [PATCH 1/3] power: core: Add generic interface to get battery
 specification.
Thread-Index: AQHP4h263BcJpDIneE+5kaYQB24XuZxWs9dQ
Date: Sat, 8 Nov 2014 10:13:11 +0000
Message-ID: <20ADAB092842284E95860F279283C5642ED8AE04@BGSMSX104.gar.corp.intel.com>
References: <1412679518-21499-1-git-send-email-jonghwa3.lee@samsung.com>
 <1412679518-21499-2-git-send-email-jonghwa3.lee@samsung.com>
In-Reply-To: <1412679518-21499-2-git-send-email-jonghwa3.lee@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +ATOMIC_NOTIFIER_HEAD(psy_battery_info_notifier);

 Isn't it good to reuse the existing power_supply_notifier for this?

> +enum battery_info_notifier_events {
> +	PSY_BATT_INFO_REGISTERED,
> +	PSY_BATT_INFO_UNREGISTERED,
> +};

If we use the power_supply_notifier, then this can be moved to
enum power_supply_notifier_events

-Jenny
