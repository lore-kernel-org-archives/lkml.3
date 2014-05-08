Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbaEHKEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:04:10 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:16772
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753829AbaEHKEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:04:08 -0400
Message-ID: <536B568C.10402@freescale.com>
Date: Thu, 8 May 2014 18:03:56 +0800
From: Hongbo Zhang <hongbo.zhang@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>, <dan.j.williams@intel.com>
CC: <vkoul@infradead.org>, <dmaengine@vger.kernel.org>,
        <scottwood@freescale.com>, <leo.li@freescale.com>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 6/8] DMA: Freescale: change descriptor release process
 for supporting async_tx
References: <1397809071-5353-1-git-send-email-hongbo.zhang@freescale.com>
 <1397809071-5353-7-git-send-email-hongbo.zhang@freescale.com>
 <20140502165053.GH32284@intel.com>
In-Reply-To: <20140502165053.GH32284@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(377454003)(479174003)(189002)(199002)(24454002)(51704005)(54356999)(92726001)(4396001)(87936001)(558084003)(81156002)(92566001)(74502001)(31966008)(50986999)(97736001)(74662001)(65816999)(81542001)(76176999)(33656001)(50466002)(2009001)(23756003)(81342001)(83322001)(19580405001)(64706001)(19580395003)(46102001)(77096999)(77982001)(86362001)(64126003)(99396002)(69596002)(20776003)(65806001)(84676001)(44976005)(85852003)(21056001)(83072002)(6806004)(76482001)(80022001)(47776003)(79102001)(68736004)(83506001)(36756003)(65956001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB298;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0205EDCD76
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=hongbo.zhang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05/03/2014 12:50 AM, Vinod Koul wrote:
> On Fri, Apr 18, 2014 at 04:17:49PM +0800, hongbo.zhang@freescale.com wrote:
>
> This need review from Dan ...
>
Dan, could you please have a look at this? thanks.


