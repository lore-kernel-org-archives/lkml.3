Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbaHTQUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 12:20:52 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:58238
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752061AbaHTQUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 12:20:50 -0400
Message-ID: <53F4CAD7.5060904@freescale.com>
Date: Wed, 20 Aug 2014 11:20:39 -0500
From: German Rivera <German.Rivera@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <stuart.yoder@freescale.com>,
        <linuxppc-release@linux.freescale.net>
Subject: Re: [RFC PATCH 1/4 v2] drivers/bus: Added Freescale Management Complex
 APIs
References: <1408496070-6252-1-git-send-email-German.Rivera@freescale.com>	 <1408496070-6252-2-git-send-email-German.Rivera@freescale.com> <1408497589.23250.12.camel@joe-AO725>
In-Reply-To: <1408497589.23250.12.camel@joe-AO725>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.88.168.50]
X-ClientProxiedBy: BLUPR05CA0063.namprd05.prod.outlook.com (10.141.20.33) To
 DM2PR03MB335.namprd03.prod.outlook.com (10.141.54.20)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03094A4065
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6049001)(6009001)(199003)(189002)(479174003)(377454003)(24454002)(377424004)(164054003)(51704005)(65816999)(79102001)(20776003)(80316001)(46102001)(86362001)(87266999)(85852003)(21056001)(64126003)(64706001)(76482001)(54356999)(76176999)(47776003)(50986999)(77982001)(83322001)(81342001)(59896002)(42186005)(81542001)(66066001)(85306004)(80022001)(106356001)(36756003)(105586002)(95666004)(107046002)(50466002)(102836001)(65806001)(74662001)(92566001)(33656002)(87976001)(74502001)(101416001)(83506001)(83072002)(77096002)(92726001)(99396002)(31966008)(110136001)(4396001)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB335;H:[10.81.33.65];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08/19/2014 08:19 PM, Joe Perches wrote:
> On Tue, 2014-08-19 at 19:54 -0500, J. German Rivera wrote:
>> APIs to access the Management Complex (MC) hardware
>> module of Freescale LS2 SoCs. This patch includes
>> APIs to check the MC firmware version and to manipulate
>> DPRC objects in the MC.
> []
>>   include/linux/fsl_dpmng.h          |  120 ++++++
>>   include/linux/fsl_dprc.h           |  790 ++++++++++++++++++++++++++++++++++++
>>   include/linux/fsl_mc_cmd.h         |  182 +++++++++
>>   include/linux/fsl_mc_sys.h         |   50 +++
>
> Why should any of these files be put in include/linux?
>
These header files are going to be shared by more than one of our 
drivers. Should they be in a new directory under include
(such as include/fsl/) or under include/linux (such as include/linux/fsl/)?

Thanks,

German
>
