Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbaIXJN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:13:59 -0400
Received: from mail-bl2on0130.outbound.protection.outlook.com ([65.55.169.130]:9616
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752389AbaIXJNx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:13:53 -0400
X-Greylist: delayed 938 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Sep 2014 05:13:53 EDT
From: Dexuan Cui <decui@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH v2] Tools: hv: vssdaemon: ignore the EBUSY on multiple
 freezing the same partition
Thread-Topic: [PATCH v2] Tools: hv: vssdaemon: ignore the EBUSY on multiple
 freezing the same partition
Thread-Index: AQHP18/jd9J77WZ/MEeiViEnXzGXqZwP+dJw
Date: Wed, 24 Sep 2014 08:57:13 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C601D69A@HKNPRD3002MB017.064d.mgd.msft.net>
References: <1411448455-12768-1-git-send-email-decui@microsoft.com>
 <20140924063203.GA29621@kroah.com>
In-Reply-To: <20140924063203.GA29621@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.133]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(189002)(13464003)(51704005)(199003)(52604005)(24454002)(164054003)(377454003)(77096002)(31966008)(85306004)(46406003)(50466002)(23726002)(33656002)(90102001)(4396001)(106116001)(106466001)(81156004)(74662003)(95666004)(77982003)(81342003)(79102003)(21056001)(74502003)(16796002)(80022003)(46102003)(120916001)(81542003)(97736003)(76482002)(10300001)(55846006)(86146001)(87936001)(92566001)(92726001)(86362001)(2656002)(83072002)(86612001)(85852003)(66066001)(64706001)(84676001)(20776003)(47776003)(69596002)(68736004)(44976005)(83322001)(19580405001)(97756001)(19580395003)(6806004)(110136001)(54356999)(50986999)(76176999)(107046002)(99396003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0301MB1207;H:mail.microsoft.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1207;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 03449D5DD1
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Greg KH
> Sent: Wednesday, September 24, 2014 14:32 PM
> To: Dexuan Cui
> Cc: linux-kernel@vger.kernel.org; driverdev-devel@linuxdriverproject.org;
> olaf@aepfle.de; apw@canonical.com; jasowang@redhat.com; Haiyang
> Zhang
> Subject: Re: [PATCH v2] Tools: hv: vssdaemon: ignore the EBUSY on multiple
> freezing the same partition
> 
> On Mon, Sep 22, 2014 at 10:00:55PM -0700, Dexuan Cui wrote:
> > v2: I added "errno = 0;" in the ioctl()
> 
> That does not belong in the changelog, put it below the --- line.
> 
> Also, you need a changelog description here, it can't be empty.
> 
> greg k-h

Thanks for pointing this out!  I'll fix it.

Thanks,
-- Dexuan
