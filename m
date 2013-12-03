Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab3LCDpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 22:45:36 -0500
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:35951
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754259Ab3LCDpb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 22:45:31 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "jlee@suse.com" <jlee@suse.com>,
        "matt@console-pimps.org" <matt@console-pimps.org>,
        "richard@nod.at" <richard@nod.at>, "cxie@redhat.com" <cxie@redhat.com>
Subject: RE: [PATCH] x86, efi: add efi_whitelist_table to use all efi
 variable storage
Thread-Topic: [PATCH] x86, efi: add efi_whitelist_table to use all efi
 variable storage
Thread-Index: AQHO50xcuy9Y6e7oj0WIb9lvfIqgUppB3tkbgAAGdvU=
Date: Tue, 3 Dec 2013 03:45:27 +0000
Message-ID: <25e63f3b748741998d2b3e04bbc53064@BN1PR05MB423.namprd05.prod.outlook.com>
References: <528C740A.6010407@jp.fujitsu.com>
  <1384963376.20536.3.camel@x230> <528DD3E0.3050606@jp.fujitsu.com>
  <1385064722.12107.1.camel@x230> <528E9EB2.3060808@jp.fujitsu.com>
  <1385078632.12107.3.camel@x230> <528EF87D.4050300@jp.fujitsu.com>
  <528EF9CE.2070305@jp.fujitsu.com>
 <1385142450.2884.1.camel@x230>,<529D4DF5.80502@jp.fujitsu.com>
In-Reply-To: <529D4DF5.80502@jp.fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [209.6.207.143]
x-forefront-prvs: 0049B3F387
x-forefront-antispam-report: SFV:NSPM;SFS:(199002)(189002)(65816001)(80022001)(66066001)(76786001)(76796001)(76576001)(558084003)(2656002)(81686001)(81816001)(33646001)(87936001)(87266001)(74316001)(74366001)(85852002)(46102001)(77096001)(56776001)(56816005)(90146001)(79102001)(54316002)(53806001)(59766001)(54356001)(77982001)(51856001)(63696002)(80976001)(4396001)(47736001)(49866001)(74876001)(74706001)(81542001)(76482001)(81342001)(83072001)(83322001)(47976001)(85306002)(50986001)(47446002)(74662001)(31966008)(69226001)(74502001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR05MB424;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:209.6.207.143;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The threshold of 5K is based on information we received from vendors. We won't be reducing it. Can you confirm that attempting to create a variable larger than the remaining space in boot services will trigger garbage collection?