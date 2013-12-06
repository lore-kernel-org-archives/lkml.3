Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab3LFIun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 03:50:43 -0500
Received: from sessmg21.ericsson.net ([193.180.251.40]:42881 "EHLO
	sessmg21.mgmt.ericsson.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751543Ab3LFIul convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 03:50:41 -0500
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Dec 2013 03:50:40 EST
X-AuditID: c1b4fb28-b7fb38e000004238-63-52a18c5aa833
From: =?iso-8859-1?Q?Bengt_J=F6nsson?= <bengt.jonsson@ericsson.com>
To: Jingoo Han <jg1.han@samsung.com>, "'Mark Brown'" <broonie@kernel.org>
CC: "'Liam Girdwood'" <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Bengt Jonsson'" <bengt.g.jonsson@stericsson.com>
Subject: RE: [PATCH 2/6] regulator: db8500-prcmu: use
 devm_regulator_register()
Thread-Topic: [PATCH 2/6] regulator: db8500-prcmu: use
 devm_regulator_register()
Thread-Index: AQHO8lIB1oaIIIhKykS/t3jxnOQ1V5pG1waA
Date: Fri, 6 Dec 2013 08:35:36 +0000
Message-ID: <E54F8889F68BA64B8355A79FE71DD99512F88E64@ESESSMB303.ericsson.se>
References: <000a01cef251$c79ea9e0$56dbfda0$%han@samsung.com>
 <000b01cef251$fc6df360$f549da20$%han@samsung.com>
In-Reply-To: <000b01cef251$fc6df360$f549da20$%han@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [153.88.183.17]
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsUyM+JvrW5Uz8Igg8V9ihZTHz5hs7i88BKr
	xbcrHUwWl3fNYXNg8dg56y67x6ZVnWwefVtWMXp83iQXwBLFZZOSmpNZllqkb5fAlfGj4xRb
	wSXmiomr1zM2ME5h7mLk5JAQMJF4veAsC4QtJnHh3nq2LkYuDiGBE4wSk288ZoJwFjNKTF/7
	lBGkik3AWeLUxx9MILaIgLvEpO9XWUGKmAXmMUqc/3AOLCEsEChxrfEbG0RRkMSPDztZIGwj
	id7nC9lBbBYBFYllU1eDncEr4Cuxbmcb0CAOoG2FEh8n54OEOQXsJI58ugXWygh03fdTa8DG
	MwuIS9x6Mp8J4moBiSV7zkN9Iyrx8vE/sDESAooSy/vlIMr1JG5MncIGYWtLLFv4GmqroMTJ
	mU9YJjCKzUIydRaSlllIWmYhaVnAyLKKUbI4tbg4N93IUC83PbdEL7UoM7m4OD9Przh1EyMw
	2g5u+a2xg7H7mv0hRmkOFiVx3qqZnUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGOeVupxK
	S77BN8ebpdhm+yrVrf5LnFeqzd01e5q+0uus1cvS2C9Pkb0m8zLedvvO1ucsH2f8ubiP4ZBq
	iMsziWarmf6frdfks/z89v34FBU/w0P73pY9CHhW8UyQmWmPR8mi1Bkdx/7avjz2zu+J3uVp
	9meXf+T2+hxqkyaUz1exVPPXxMyLwluVWIozEg21mIuKEwHZnklzhAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: Jingoo Han [mailto:jg1.han@samsung.com] 
Sent: den 6 december 2013 08:09
To: 'Mark Brown'
Cc: 'Liam Girdwood'; linux-kernel@vger.kernel.org; 'Jingoo Han'; 'Bengt Jonsson'
Subject: [PATCH 2/6] regulator: db8500-prcmu: use devm_regulator_register()

Use devm_regulator_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
