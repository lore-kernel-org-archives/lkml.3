Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbaJOL2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 07:28:05 -0400
Received: from mail-by2on0144.outbound.protection.outlook.com ([207.46.100.144]:46673
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752443AbaJOL2D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 07:28:03 -0400
From: Thomas Shao <huishao@microsoft.com>
To: Richard Cochran <richardcochran@gmail.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH v2 2/2] hyperv: Implement Time Synchronization using
 host time sample
Thread-Topic: [PATCH v2 2/2] hyperv: Implement Time Synchronization using
 host time sample
Thread-Index: AQHP6EpV0yTtUPFvLUmVTRuWJYo4nZww4UkAgAAArUCAAAZPAIAAHKPw
Date: Wed, 15 Oct 2014 11:27:43 +0000
Message-ID: <CD2CABCB2C0A0D4682C5F8AD840141540C1A46@HKXPRD3002MB006.064d.mgd.msft.net>
References: <1413362404-16284-1-git-send-email-huishao@microsoft.com>
 <20141015091808.GB5300@localhost.localdomain>
 <CD2CABCB2C0A0D4682C5F8AD840141540C171E@HKXPRD3002MB006.064d.mgd.msft.net>
 <20141015094308.GA5452@localhost.localdomain>
In-Reply-To: <20141015094308.GA5452@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.4]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(164054003)(189002)(24454002)(377454003)(13464003)(51704005)(199003)(52604005)(81156004)(106466001)(64706001)(66066001)(26826002)(46102003)(80022003)(106116001)(47776003)(20776003)(86146001)(23726002)(31966008)(16796002)(68736004)(76482002)(33656002)(107046002)(110136001)(77096002)(93886004)(85306004)(120916001)(95666004)(1411001)(6806004)(21056001)(86612001)(99396003)(4396001)(85852003)(44976005)(84676001)(92566001)(97736003)(46406003)(87936001)(92726001)(86362001)(50466002)(50986999)(2656002)(19580405001)(19580395003)(55846006)(69596002)(76176999)(54356999)(97756001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB1212;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1212;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0365C0E14B
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=huishao@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Richard Cochran [mailto:richardcochran@gmail.com]
> Sent: Wednesday, October 15, 2014 5:43 PM
> To: Thomas Shao
> Cc: tglx@linutronix.de; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com; KY Srinivasan
> Subject: Re: [PATCH v2 2/2] hyperv: Implement Time Synchronization using
> host time sample
> 
> On Wed, Oct 15, 2014 at 09:21:33AM +0000, Thomas Shao wrote:
> >
> > In V2, I address all the Dan's comments.
> 
> It is customary to detail the changes in each patch series revision, in order to
> make things easier for the reviewers.
> 

OK. Thanks for pointing that out, Richard.

> Thanks,
> Richard
