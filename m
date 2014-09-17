Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbaIQXup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 19:50:45 -0400
Received: from mail-bn1on0141.outbound.protection.outlook.com ([157.56.110.141]:13680
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752039AbaIQXun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 19:50:43 -0400
Message-ID: <541A1E49.2080404@freescale.com>
Date: Wed, 17 Sep 2014 18:50:33 -0500
From: German Rivera <German.Rivera@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <stuart.yoder@freescale.com>,
        <Kim.Phillips@freescale.com>, <scottwood@freescale.com>,
        <agraf@suse.de>, <linuxppc-release@linux.freescale.net>
Subject: Re: [PATCH 2/4] drivers/bus: Freescale Management Complex (fsl-mc)
 bus driver
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>	 <1410456864-27890-3-git-send-email-German.Rivera@freescale.com> <1410461351.9942.19.camel@joe-AO725>
In-Reply-To: <1410461351.9942.19.camel@joe-AO725>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.88.168.50]
X-ClientProxiedBy: BLUPR08CA0051.namprd08.prod.outlook.com (10.141.200.31) To
 BLUPR03MB327.namprd03.prod.outlook.com (10.141.48.18)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0337AFFE9A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(6049001)(199003)(51704005)(377454003)(479174003)(24454002)(189002)(23746002)(83322001)(86362001)(65816999)(50986999)(87266999)(101416001)(31966008)(99396002)(36756003)(92726001)(92566001)(83072002)(85852003)(4396001)(21056001)(90102001)(76176999)(54356999)(47776003)(64706001)(20776003)(87976001)(74662003)(74502003)(77982003)(81342003)(81542003)(46102003)(79102003)(65956001)(80022003)(65806001)(66066001)(59896002)(85306004)(77096002)(95666004)(106356001)(105586002)(107046002)(110136001)(42186005)(50466002)(33656002)(97736003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB327;H:[10.81.33.65];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/11/2014 01:49 PM, Joe Perches wrote:
>
>> +out:
>> +	pr_debug("%s: %s %s\n", __func__, dev_name(dev),
>> +		 found ? "matched" : "not matched");
>
> Thia should probably use dev_dbg
>
> 	dev_dbg(dev, "%smatched\n", found ? "" : "not ");
>
> and let the dynamic debug mechanism emit the
> function name if desired.
>
>
Ok, I'll make this change in the v2 respin
