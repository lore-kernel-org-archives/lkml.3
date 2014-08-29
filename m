Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbaH2O1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 10:27:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:36765 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727AbaH2O1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 10:27:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,424,1406617200"; 
   d="scan'208";a="473821888"
From: Laurentiu Palcu <laurentiu.palcu@intel.com>
To: Jonathan Cameron <jic23@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>,
        Derek Basehore <dbasehore@chromium.org>,
        Teodora Baluta <teodora.baluta@intel.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH 0/3] staging: iio: light: isl29018: add support for other chips
Date: Fri, 29 Aug 2014 17:26:19 +0300
Message-Id: <1409322382-30021-1-git-send-email-laurentiu.palcu@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset adds support for 2 similar ALS chips: ISL29023 and ISL29035.

The chip I performed tests on was a ISL29035, since I didn't have eval boards, for the
other 2 chips, handy.

The registers tables for each chip can be found here:

ISL29018: [1] - page 10
ISL29023: [2] - page 8
ISL29035: [3] - page 10

[1] http://www.intersil.com/content/dam/Intersil/documents/isl2/isl29018.pdf
[2] http://www.intersil.com/content/dam/Intersil/documents/isl2/isl29023.pdf
[3] http://www.intersil.com/content/dam/Intersil/documents/isl2/isl29035.pdf

thanks,
laurentiu

Laurentiu Palcu (3):
  staging: iio: light: isl29018: fix typo
  staging: iio: light: isl29018: add support for isl29023 and isl29035
  staging: iio: light: isl29018: add ACPI support

 drivers/staging/iio/light/isl29018.c | 205 ++++++++++++++++++++++++++++++-----
 1 file changed, 179 insertions(+), 26 deletions(-)

-- 
1.9.1

