Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab3JYQtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 12:49:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:6983 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610Ab3JYQtl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 12:49:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="312746083"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Anton Vorontsov" <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: RE: [PATCH 0/7] power_supply: Introduce Power Supply Charging
 Framework
Thread-Topic: [PATCH 0/7] power_supply: Introduce Power Supply Charging
 Framework
Thread-Index: AQHOuEUek7OFtQpcKUS59NhXm/gFvpoF049A
Date: Fri, 25 Oct 2013 16:49:28 +0000
Message-ID: <20ADAB092842284E95860F279283C5640AA96A13@BGSMSX104.gar.corp.intel.com>
References: <1379959445-28207-1-git-send-email-jenny.tc@intel.com>
In-Reply-To: <1379959445-28207-1-git-send-email-jenny.tc@intel.com>
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

Anton,

Could you please review these patches?

-Jenny

> -----Original Message-----
> From: Tc, Jenny
> Sent: Monday, September 23, 2013 11:34 PM
> To: linux-kernel@vger.kernel.org; Anton Vorontsov; Anton Vorontsov
> Cc: Tc, Jenny
> Subject: [PATCH 0/7] power_supply: Introduce Power Supply Charging Framework
> 
> The Power Supply charging framework connects multiple subsystems to do charging in a
> generic way. The framework makes use of different new features - Battery Identification
> framework, pluggable charging algorithms, charger cable arbitrations. PSE compliant
> charging algorithm also enabled as part of this patch set.
> 
> With this framework the charging logic can be kept outside the charger driver.The charger
> driver just need to expose th get_property and set_property functions to get and set a
> specific set of power supply properties. The driver can convert these values to the
> hardware configurations to setup charging.
> 
> 
> Jenny TC (7):
>   power_supply: Add charger control properties
>   power_supply : add charger cable properties
>   power_supply: add throttle state
>   power_supply: Add power_supply notifier
>   power_supply : Introduce battery identification framework
>   power_supply: Introduce Power Supply charging framework
>   power_supply: Introduce PSE compliant algorithm
> 
>  Documentation/power/power_supply_class.txt |  202 ++++++
>  drivers/power/Kconfig                      |   30 +
>  drivers/power/Makefile                     |    3 +
>  drivers/power/battery_id.c                 |   87 +++
>  drivers/power/charging_algo_pse.c          |  202 ++++++
>  drivers/power/power_supply.h               |   21 +
>  drivers/power/power_supply_charger.c       | 1011 ++++++++++++++++++++++++++++
>  drivers/power/power_supply_charger.h       |  130 ++++
>  drivers/power/power_supply_core.c          |   38 ++
>  drivers/power/power_supply_sysfs.c         |    8 +
>  include/linux/power/battery_id.h           |  100 +++
>  include/linux/power_supply.h               |  335 +++++++++
>  12 files changed, 2167 insertions(+)
>  create mode 100644 drivers/power/battery_id.c  create mode 100644
> drivers/power/charging_algo_pse.c  create mode 100644
> drivers/power/power_supply_charger.c
>  create mode 100644 drivers/power/power_supply_charger.h
>  create mode 100644 include/linux/power/battery_id.h
> 
> --
> 1.7.9.5

