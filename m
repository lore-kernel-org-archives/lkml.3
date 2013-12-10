Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650Ab3LJU3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:29:35 -0500
Received: from mail-db8lp0188.outbound.messaging.microsoft.com ([213.199.154.188]:27178
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750836Ab3LJU3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:29:33 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zz98dI9371I936eI542I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh8275dh1de097hz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
Message-ID: <1386707357.10013.114.camel@snotra.buserror.net>
Subject: Re: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU (PAMU)
From: Scott Wood <scottwood@freescale.com>
To: "Bharat.Bhushan@freescale.com" <Bharat.Bhushan@freescale.com>
CC: "'Wood Scott-B07421'" <scottwood@freescale.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "agraf@suse.de" <agraf@suse.de>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 10 Dec 2013 14:29:17 -0600
In-Reply-To: <34c6142137194b1cbd2336013ed3b10d@BN1PR03MB266.namprd03.prod.outlook.com>
References: <1384838233-24847-1-git-send-email-Bharat.Bhushan@freescale.com>
	 <1384973243.2879.361.camel@ul30vt.home>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D0721D9AC@039-SN2MPN1-012.039d.mgd.msft.net>
	 <1385066603.2879.414.camel@ul30vt.home>
	 <1385066835.1403.489.camel@snotra.buserror.net>
	 <1385067648.2879.421.camel@ul30vt.home>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D0722C180@039-SN2MPN1-012.039d.mgd.msft.net>
	 <1386288052.7375.100.camel@snotra.buserror.net>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D07251EFF@039-SN2MPN1-012.039d.mgd.msft.net>
	 <1386357907.7375.127.camel@snotra.buserror.net>
	 <34c6142137194b1cbd2336013ed3b10d@BN1PR03MB266.namprd03.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My e-mail address is <scottwood@freescale.com>, not
<IMCEAEX-_O=MMS_OU=EXTERNAL+20+28FYDIBOHF25SPDLT
+29_CN=RECIPIENTS_CN=F0FAAC8D7E74473A9EE1C45B068D838A@namprd03.prod.outlook.com>

On Tue, 2013-12-10 at 05:37 +0000, Bharat.Bhushan@freescale.com wrote:
> 
> > -----Original Message-----
> > From: Wood Scott-B07421
> > Sent: Saturday, December 07, 2013 12:55 AM
> > To: Bhushan Bharat-R65777
> > Cc: Alex Williamson; linux-pci@vger.kernel.org; agraf@suse.de; Yoder Stuart-
> > B08248; iommu@lists.linux-foundation.org; bhelgaas@google.com; linuxppc-
> > dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU (PAMU)
> > 
> > If the administrator does not opt into this partial loss of isolation, then once
> > you run out of MSI groups, new users should not be able to set up MSIs.
> 
> So mean vfio should use Legacy when out of MSI banks?

Yes, if the administrator hasn't granted permission to share.

-Scott



