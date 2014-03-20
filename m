Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695AbaCTNZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 09:25:14 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:14613
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756925AbaCTNZH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 09:25:07 -0400
From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC: "jejb@kernel.org" <jejb@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Prakash, Sathya" <Sathya.Prakash@lsi.com>,
        "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sreekanthreddy0547@gmail.com" <sreekanthreddy0547@gmail.com>
Subject: RE: [PATCH 02/11][SCSI]mpt2sas: Added new driver module Parameter
 disable_eedp to Disable EEDP Support
Thread-Topic: [PATCH 02/11][SCSI]mpt2sas: Added new driver module Parameter
 disable_eedp to Disable EEDP Support
Thread-Index: AQHPP5vBqPQBwkFGE0WjfSIQSqqRkprhC0nygAf4j4CAAPwHQA==
Date: Thu, 20 Mar 2014 13:25:00 +0000
Message-ID: <a13fdb6e86244cf886f992f1ec576f42@DM2PR07MB302.namprd07.prod.outlook.com>
References: <20140314153622.GA7947@lsi.com>
	 <yq1r464wm7s.fsf@sermon.lab.mkp.net>
 <1395267671.2185.63.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1395267671.2185.63.camel@dabdike.int.hansenpartnership.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.19.224.250]
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019001)(6009001)(428001)(164054003)(199002)(189002)(51704005)(85852003)(76796001)(76576001)(92566001)(59766001)(79102001)(77982001)(77096001)(80976001)(69226001)(47736001)(54356001)(49866001)(53806001)(4396001)(90146001)(50986001)(47976001)(81342001)(51856001)(46102001)(74706001)(81542001)(54316002)(81686001)(81816001)(83072002)(56776001)(76482001)(66066001)(65816001)(80022001)(97336001)(97186001)(87266001)(56816005)(85306002)(95666003)(47446002)(74502001)(74662001)(86362001)(31966008)(93516002)(94316002)(33646001)(87936001)(20776003)(93136001)(95416001)(74876001)(83322001)(2656002)(63696002)(74316001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR07MB285;H:DM2PR07MB302.namprd07.prod.outlook.com;FPR:2E3EC5E1.AC301F25.5AE19F79.4EABD73.2017F;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> Sreekanth> A new mpt2sas driver module parameter 'disable_eedp' is
>> Sreekanth> added to Disable EEDP support. By default DIF support is
>> Sreekanth> enabled in the driver and this module parameter would allow
>> Sreekanth> users to turn it off.
>>
>> Why don't you just set the prot_mask module parameter to 0?
>
>Is there an answer to this?  It's holding up your patch submission.
>
>James
>


Hi Martin,

The prot_mask module parameter is defined for the purpose of setting the DIF and DIX capabilities. 
The disable_eedp module parameter is added with the intent to disable the complete EEDP related code and operations. This include even reading  manufacting pages to get EEDPTagMode etc. 
Agree that this could also be achieved using prot_mask. We are giving new parameter to be clear that we are disabling the complete EEDP.

Thanks,
Sreekanth
