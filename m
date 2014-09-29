Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbaI2Dvg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 23:51:36 -0400
Received: from mail-bn1bbn0104.outbound.protection.outlook.com ([157.56.111.104]:37088
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751144AbaI2Dvf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 23:51:35 -0400
From: KY Srinivasan <kys@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/1] Drivers: net-next: hyperv: Fix a bug in
 netvsc_start_xmit()
Thread-Topic: [PATCH 1/1] Drivers: net-next: hyperv: Fix a bug in
 netvsc_start_xmit()
Thread-Index: AQHP24bmfLJyqmOKA0Wxbuxha3HFc5wXcI2AgAAJRNA=
Date: Mon, 29 Sep 2014 03:51:32 +0000
Message-ID: <90e56f4692144d77b9d1cee3a2cea667@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1411958991-28049-1-git-send-email-kys@microsoft.com>
 <20140928.231647.1355757349883305047.davem@davemloft.net>
In-Reply-To: <20140928.231647.1355757349883305047.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [131.107.174.160]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0710;
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 034902F5BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(51704005)(189002)(13464003)(377454003)(77096002)(19580405001)(108616004)(105586002)(106116001)(83072002)(33646002)(85306004)(31966008)(77982003)(46102003)(54356999)(83322001)(92566001)(81542003)(19580395003)(86362001)(80022003)(74662003)(106356001)(2656002)(110136001)(74502003)(81342003)(74316001)(95666004)(79102003)(76176999)(107046002)(85852003)(87936001)(99286002)(21056001)(76576001)(97736003)(20776003)(66066001)(76482002)(4396001)(86612001)(90102001)(101416001)(50986999)(64706001)(99396003)(10300001)(120916001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0710;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Sunday, September 28, 2014 8:17 PM
> To: KY Srinivasan
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; stable@vger.kernel.org
> Subject: Re: [PATCH 1/1] Drivers: net-next: hyperv: Fix a bug in
> netvsc_start_xmit()
> 
> From: "K. Y. Srinivasan" <kys@microsoft.com>
> Date: Sun, 28 Sep 2014 19:49:51 -0700
> 
> > After the packet is successfully sent, we should not touch the skb as
> > it may have been freed. This patch is based on the work done by Long
> > Li <longli@microsoft.com>.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Tested-by: Long Li <longli@microsoft.com>
> > Cc: <stable@vger.kernel.org>
> 
> You hyperv guys really have to get your act together.  This is not properly
> submitted.
> 
> Most importantly, this is a serious reference to free memory bug.
> Therefore it should be targetted at 'net' not 'net-next'.
> 
> Secondly, you do not CC: stable for networking changes, you instead ask me
> to queue it up for my next batch of -stable networking changes.
> 
> Thirdly, your Subject line is malformed.  You should not use
> "Drivers: " as a prefix.  Just the driver name is sufficient.
> You should also not mentionen the target GIT tree outside of the [PATCH ...]
> bracketed area.
> 
> Also, please be cognizant of how much of my time you unnecessarily
> consume when you make a malformed submission like this.  That is time I
> could spend reviewing other patches.

Sorry about that; I will resubmit this patch after addressing all the issues you have raised.

Regards,

K. Y
