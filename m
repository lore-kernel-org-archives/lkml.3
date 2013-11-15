Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab3KOP1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 10:27:30 -0500
Received: from Smtp1.Lantiq.com ([195.219.66.200]:16940 "EHLO smtp1.lantiq.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab3KOP1V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 10:27:21 -0500
X-Greylist: delayed 589 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Nov 2013 10:27:20 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqAEAIg6hlIKQLW9/2dsb2JhbABZhBK/I4E9dIIlAQEBAwF5BQsCAQgNFSQyJQIECgQFCIdzC8BrjzgxBxaDCoERA4kKlWyOT4Iq
X-IronPort-AV: E=McAfee;i="5400,1158,7259"; a="2590501"
From: <thomas.langer@lantiq.com>
To: <christophe.leroy@c-s.fr>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <jerome.chantelauze.ext@c-s.fr>
Subject: RE: [PATCH v2] WAN: Adding support for Infineon PEF2256 E1 chipset
 (FALC56)
Thread-Topic: [PATCH v2] WAN: Adding support for Infineon PEF2256 E1 chipset
 (FALC56)
Thread-Index: AQHO1xNoGhC8mnwr90q1xGzgqw1KnpomcavA
Date: Fri, 15 Nov 2013 15:17:29 +0000
Message-ID: <593AEF6C47F46446852B067021A273D6D9A05202@MUCSE039.lantiq.com>
References: <201311011501.rA1F1suj007279@localhost.localdomain>
In-Reply-To: <201311011501.rA1F1suj007279@localhost.localdomain>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.64.175.92]
x-tm-as-product-ver: SMEX-10.0.0.1412-7.000.1014-20292.007
x-tm-as-result: No--42.309900-0.000000-31
x-tm-as-user-approved-sender: Yes
x-tm-as-user-blocked-sender: No
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Christophe,

Christophe Leroy wrote on 2013-11-01:

> The patch adds WAN support for Infineon FALC56 - PEF2256 E1 Chipset.

can you please replace "Infineon" with "Lantiq"?
The former "wire-line" business-unit was transferred into an own company some years ago.

Maybe provide a comment in the description or binding document, to avoid more confusion about this.

> 
> Signed-off-by: Jerome Chantelauze <jerome.chantelauze.ext@c-s.fr>
> Acked-by: Christophe Leroy <christophe.leroy@c-s.fr>
> 

Thanks,
Thomas

---
There are two hard things in computer science: cache invalidation, naming things, and off-by-one errors.
---

