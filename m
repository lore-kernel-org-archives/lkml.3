Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934989AbaFTQnn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:43:43 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25784 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923AbaFTQnk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:43:40 -0400
X-IronPort-AV: E=McAfee;i="5600,1067,7475"; a="44458920"
X-IronPort-AV: E=Sophos;i="5.01,514,1400050800"; 
   d="scan'208";a="753268457"
From: "Kondratiev, Vladimir" <vkondrat@qti.qualcomm.com>
To: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        qca_vkondrat <qca_vkondrat@qca.qualcomm.com>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        wil6210 <wil6210@qca.qualcomm.com>, netdev <netdev@vger.kernel.org>
Subject: RE: randconfig build error with next-20140604, in
 drivers/net/wireless/ath/wil6210/debugfs.c
Thread-Topic: randconfig build error with next-20140604, in
 drivers/net/wireless/ath/wil6210/debugfs.c
Thread-Index: AQHPjKRmAxX0MRjPrEqpQcVECbGk8Zt6NAtW
Date: Fri, 20 Jun 2014 16:43:38 +0000
Message-ID: <A5CA08B46412E243958C77F3825F4395270AB72A@NASANEXD02E.na.qualcomm.com>
References: <CA+r1ZhiT6hHwA2urc-DXUxucvJYaYdq-dZZSAFrgd3du_DDrww@mail.gmail.com>
In-Reply-To: <CA+r1ZhiT6hHwA2urc-DXUxucvJYaYdq-dZZSAFrgd3du_DDrww@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.106.115.192]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building with the attached random configuration file,

drivers/built-in.o: In function `wil_vring_debugfs_show':
debugfs.c:(.text+0x3a331c): undefined reference to `__udivdi3'
make: *** [vmlinux] Error 1

Patch already sent.

Thanks, Vladimir