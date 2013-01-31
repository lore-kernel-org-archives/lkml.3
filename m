Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab3AaLo0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 06:44:26 -0500
Received: from mga02.intel.com ([134.134.136.20]:53906 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab3AaLoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 06:44:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,575,1355126400"; 
   d="scan'208";a="255401733"
From: "Woodhouse, David" <david.woodhouse@intel.com>
To: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "kim.phillips@freescale.com" <kim.phillips@freescale.com>
CC: "Woodhouse, David" <david.woodhouse@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "daniel.santos@pobox.com" <daniel.santos@pobox.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robherring2@gmail.com" <robherring2@gmail.com>
Subject: Re: [RFC] arm: use built-in byte swap function
Thread-Topic: [RFC] arm: use built-in byte swap function
Thread-Index: Ac3/qEqryq8jjbGdz0yFuzpMnvmBrg==
Date: Thu, 31 Jan 2013 11:44:13 +0000
Message-ID: <qqqkinln5frpbwne2vswtgsg.1359632635493@email.android.com>
Reply-To: "Woodhouse, David" <david.woodhouse@intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="utf-8"
Content-ID: <2CCF10BF028E064792A9A93E2C248FB1@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0VBiQNA019942

A quick test showed I only dropped 20 bytes from net/ipv4/built-in.o but that's with no 16-bit swap support (gcc 4.7).


--
dwmw2

(Apologies for HTML and top-posting; Android mailer is broken.)
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
