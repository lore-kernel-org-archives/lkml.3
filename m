Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbaGNT7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:59:22 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:30756
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756827AbaGNT7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:59:19 -0400
X-WSS-ID: 0N8PWUO-07-9WC-02
X-M-MSG: 
Message-ID: <53C4368E.9090103@amd.com>
Date: Mon, 14 Jul 2014 14:59:10 -0500
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <clemens@ladisch.de>, <jdelvare@suse.de>, <linux@roeck-us.net>,
        <rdunlap@infradead.org>, <bhelgaas@google.com>,
        <lm-sensors@lm-sensors.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] hwmon, k10temp: Add support for AMD F15h M60h processor
References: <1405369388-12729-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20140714195128.GA25124@pd.tnic>
In-Reply-To: <20140714195128.GA25124@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(189002)(199002)(24454002)(377454003)(479174003)(51704005)(81342001)(83072002)(50986999)(33656002)(85852003)(97736001)(92726001)(87266999)(76176999)(92566001)(99396002)(54356999)(102836001)(65816999)(76482001)(64706001)(80022001)(59896001)(20776003)(83506001)(47776003)(65956001)(77982001)(23676002)(81542001)(36756003)(85306003)(68736004)(21056001)(83322001)(84676001)(101416001)(80316001)(74662001)(46102001)(87936001)(95666004)(50466002)(107046002)(110136001)(86362001)(4396001)(105586002)(74502001)(31966008)(79102001);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB046;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02723F29C4
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/14/2014 2:51 PM, Borislav Petkov wrote:
> On Mon, Jul 14, 2014 at 03:23:08PM -0500, Aravind Gopalakrishnan wrote:
>>   
>> @@ -211,6 +228,7 @@ static const struct pci_device_id k10temp_id_table[] = {
>>   	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F3) },
>>   	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M10H_F3) },
>>   	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M30H_NB_F3) },
>> +	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M60H_NB_F3) },
>>   	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_NB_F3) },
>>   	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_M30H_NB_F3) },
>>   	{}
>> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
>> index 7fa3173..3c8e328 100644
>> --- a/include/linux/pci_ids.h
>> +++ b/include/linux/pci_ids.h
>> @@ -520,6 +520,7 @@
>>   #define PCI_DEVICE_ID_AMD_15H_M10H_F3	0x1403
>>   #define PCI_DEVICE_ID_AMD_15H_M30H_NB_F3 0x141d
>>   #define PCI_DEVICE_ID_AMD_15H_M30H_NB_F4 0x141e
>> +#define PCI_DEVICE_ID_AMD_15H_M60H_NB_F3 0x1573
> I'm assuming this is used somewhere else besides k10temp.c?
>

Yeah, will most likely need to add EDAC bits. But that is something I 
can't test now.

So will have to do it only in due time.. :)

-Aravind.
