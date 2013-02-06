Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab3BFKuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:50:24 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:16724 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751539Ab3BFKuW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:50:22 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371I542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5hbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Joerg Roedel <joro@8bytes.org>, Stuart Yoder <b08248@gmail.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 4/5] iommu: Add domain window handling functions
Thread-Topic: [PATCH 4/5] iommu: Add domain window handling functions
Thread-Index: AQHOAto2CEpxyQTtfEOnxKNftHJz6JhqADmAgAAM2QCAAEzXgIACSSMAgAAGmlA=
Date: Wed, 6 Feb 2013 10:49:54 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D37B108@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1359983924-28952-1-git-send-email-joro@8bytes.org>
 <1359983924-28952-5-git-send-email-joro@8bytes.org>
 <CALRxmdCiSZgoqd8tp90kPCdA=s7SWZCTwKsFnWu7S5=U7+eRLQ@mail.gmail.com>
 <20130204185650.GP25591@8bytes.org>
 <CALRxmdD9Ock04AoUtF9FT_uY5C5Eb7cSPmtCM6WK=StNB_iYkQ@mail.gmail.com>
 <20130206102607.GB2634@8bytes.org>
In-Reply-To: <20130206102607.GB2634@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.132.45]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Joerg.

> -----Original Message-----
> From: Joerg Roedel [mailto:joro@8bytes.org]
> Sent: Wednesday, February 06, 2013 3:56 PM
> To: Stuart Yoder
> Cc: Sethi Varun-B16395; iommu@lists.linux-foundation.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH 4/5] iommu: Add domain window handling functions
> 
> On Mon, Feb 04, 2013 at 05:31:51PM -0600, Stuart Yoder wrote:
> > On Mon, Feb 4, 2013 at 12:56 PM, Joerg Roedel <joro@8bytes.org> wrote:
> > > Okay. So if your architecture supports sizes over 2^32 then size_t
> > > probably is already 64bits, right?
> >
> > No, on a 32-bit platform size_t would generally be 32-bits.  But the
> PAMU
> > is independent of that.   I think we should just make it a u64.
> 
> Okay, you can find the patches in the 'core' branch of the iommu-tree.
> They are also included in my next branch. You can use them now to base
> the PAMU patches on it.
> 
> 
> 	Joerg
> 
> 


