Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162646AbaDCILB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 04:11:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:60732 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162447AbaDCIKp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 04:10:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,785,1389772800"; 
   d="scan'208";a="486366129"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: "mika.westerberg@linux.intel.com" <mika.westerberg@linux.intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: How to pass I2C platform_data under ACPI
Thread-Topic: How to pass I2C platform_data under ACPI
Thread-Index: Ac9PFCVxc1BkxaEVQoqK2pGHEHD28Q==
Date: Thu, 3 Apr 2014 08:10:40 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD57463568@BGSMSX104.gar.corp.intel.com>
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

Hi All,

I am trying to enable a i2c client driver under ACPI. The device is being enumerated behind adapter device and I am getting IRQ resource as well.

The problem I have now is, how do I pass the platform data to driver?

struct i2c_board_info {
        char            type[I2C_NAME_SIZE];
        unsigned short  flags;
        unsigned short  addr;
        void            *platform_data; ===========> how can I initialize this filed.
        struct dev_archdata     *archdata;
        struct device_node *of_node;
        struct acpi_dev_node acpi_node;
        int             irq;
};
 
In non ACPI environment I used to initialize the platform_data under board or platforms files. Under ACPI how do I do that?

Thanks,
Ram
