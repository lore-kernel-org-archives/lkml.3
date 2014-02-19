Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbaBSTDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 14:03:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:35035 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139AbaBSTDG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 14:03:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,507,1389772800"; 
   d="scan'208";a="486030525"
From: "Luck, Tony" <tony.luck@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andy Lutomirski <luto@amacapital.net>
CC: Wolfram Sang <wsa@the-dreams.de>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rui Wang <ruiv.wang@gmail.com>
Subject: RE: [PATCH v6 4/4] i2c, i2c_imc: Add DIMM bus code
Thread-Topic: [PATCH v6 4/4] i2c, i2c_imc: Add DIMM bus code
Thread-Index: AQHPLaOoTcezEbN7F0GXS4ur/mEeLZq87pWw
Date: Wed, 19 Feb 2014 19:03:03 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31DCC6F8@ORSMSX106.amr.corp.intel.com>
References: <cover.1387588711.git.luto@amacapital.net>
 <15eccfa508fd0f55230c4274e3e968f91a123b73.1387588711.git.luto@amacapital.net>
 <20140219151626.GA13973@katana>
 <CALCETrVBPzGqaXbZVgUZMw7D5U5YnUMJOEsw1r=TceLYjJ39JA@mail.gmail.com>
 <20140220035128.14da0f79.m.chehab@samsung.com>
In-Reply-To: <20140220035128.14da0f79.m.chehab@samsung.com>
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

> (I'm c/c Tony here, as he also shared the same concern that I had on a 
> previous feedback about using I2C to talk with the DIMM).

Correct - I've heard the same issues that reads on I2C can be misinterpreted
as writes ... and oops, you have a brick.

What is the larger context/  What problem are we trying to solve?

-Tony
