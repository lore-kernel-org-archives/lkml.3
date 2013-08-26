Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab3HZKXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 06:23:36 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:24114
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752147Ab3HZKXe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 06:23:34 -0400
X-Forefront-Antispam-Report: CIP:192.19.193.42;KIP:(null);UIP:(null);IPV:NLI;H:paledge01.lsi.com;RD:paledge01.lsi.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz9371I542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh8275dh1de097hz2fh2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h1155h)
From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
To: Jan Vesely <jvesely@redhat.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley (JBottomley@parallels.com)" 
	<JBottomley@parallels.com>
CC: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>,
        Tomas Henzl <thenzl@redhat.com>
Date: Mon, 26 Aug 2013 15:52:21 +0530
Subject: RE: [PATCH 0/2] mpt{2,3}sas remove disconnected phys on topology
 change
Thread-Topic: [PATCH 0/2] mpt{2,3}sas remove disconnected phys on topology
 change
Thread-Index: Ac6OniBe6EkK5yWwQHuM4CDvYnurtQTp8z7w
Message-ID: <DCD177647606E9419ED923E0C8C4AA723006D9A536@inbmail02.lsi.com>
References: <1375351291-27107-1-git-send-email-jvesely@redhat.com>
In-Reply-To: <1375351291-27107-1-git-send-email-jvesely@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: lsi.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%PARALLELS.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

This patch set seem to be fine. Please consider this patch set.

Regards,
Sreekanth

>-----Original Message-----
>From: Jan Vesely [mailto:jvesely@redhat.com]
>Sent: Thursday, August 01, 2013 3:31 PM
>To: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
>Cc: Jan Vesely; Nandigama, Nagalakshmi; Reddy, Sreekanth; Tomas Henzl
>Subject: [PATCH 0/2] mpt{2,3}sas remove disconnected phys on topology
>change
>
>From: Jan Vesely <jvesely@redhat.com>
>
>These two patches add phy removal on link loss. This change keeps sysfs up-
>to-date with actually connected phys. Without these patches,  disconnected
>phys remain listed under their former ports.
>
>tested on both mpt2sas and mpt3sas hw.
>
>CC: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
>CC: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
>CC: Tomas Henzl <thenzl@redhat.com>
>Signed-off-by: Jan Vesely <jvesely@redhat.com>
>
>Jan Vesely (2):
>  mpt2sas: Remove phys on topology change.
>  mpt3sas: Remove phys on topology change
>
> drivers/scsi/mpt2sas/mpt2sas_transport.c |    5 ++++-
> drivers/scsi/mpt3sas/mpt3sas_transport.c |    5 ++++-
> 2 files changed, 8 insertions(+), 2 deletions(-)
>


