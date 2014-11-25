Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375AbaKYTOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 14:14:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:19550 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbaKYTOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 14:14:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,457,1413270000"; 
   d="scan'208";a="643407397"
From: "Akers, Jason B" <jason.b.akers@intel.com>
To: Phillip Susi <psusi@ubuntu.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
CC: "Karkra, Kapil" <kapil.karkra@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dgilbert@interlog.com" <dgilbert@interlog.com>
Subject: RE: [RFC PATCH] sg3_utils: Added hybrid information log utility
Thread-Topic: [RFC PATCH] sg3_utils: Added hybrid information log utility
Thread-Index: AQHP87RO91jYuQrQI0S2aCBQAHK4R5xxLZUAgACkF6A=
Date: Tue, 25 Nov 2014 19:13:09 +0000
Message-ID: <372C7AE269BA5E4D92B1082F530ED4B88A13F692@ORSMSX110.amr.corp.intel.com>
References: <20141029195400.5225.96984.stgit@stg-AndroidDev-VirtualBox>
 <20141029195720.5225.51331.stgit@stg-AndroidDev-VirtualBox>
 <5473CE5C.7010300@ubuntu.com>
In-Reply-To: <5473CE5C.7010300@ubuntu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAPJEtHP011189

Hi Phillip,
It turns out that this patch was based on an old github repository that doesn't appear to be updated. Doug Gilbert reached out after the initial RFC and directed us to his page (http://sg.danny.cz/sg/) where he has updated sg3_utils code.

As we continue to work through the feedback from our SSHD kernel patches, I'm going to follow up with Doug again on sg3_utils.

> -----Original Message-----
> From: Phillip Susi [mailto:psusi@ubuntu.com]
> Sent: Monday, November 24, 2014 4:34 PM
> To: Akers, Jason B; linux-ide@vger.kernel.org
> Cc: Karkra, Kapil; Williams, Dan J; linux-kernel@vger.kernel.org;
> dgilbert@interlog.com
> Subject: Re: [RFC PATCH] sg3_utils: Added hybrid information log utility
> 
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
> 
> On 10/29/2014 03:57 PM, Jason B. Akers wrote:
> > From: Kapil Karkra <kapil.karkra@intel.com>
> >
> > A solid state hybrid drive (SSHD) is a hard drive with a small
> > embedded NAND. Host drivers can manage this NAND using the
> commands
> > defined by SATA 3.2 standard. One SATA command that provides
> > visibility into the SSHD's cache behavior is get hybrid log command.
> > This augmentation allows users to issue the command as
> > follows:
> >
> > sg_sat_get_hybrid_log /dev/sdc assuming /dev/sdc is an SSHD.
> >
> > patch applies to the following sourcebase from where to clone:
> > https://github.com/hreinecke/sg3_utils.git
> 
> I cloned that repo and the patch does not apply cleanly.  git am -3 says the
> referenced blobs are not found and it has conflicts in src/Makefile.am.  I
> manually fixed that up and then it fails to link due to unresolved externals.
> 
> 
> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1
> 
> iQEcBAEBCgAGBQJUc85UAAoJENRVrw2cjl5RR3YIAJOF0fcTkF5pM0OIA87hK8k
> 8
> ujwflBTy66ZbPzXMD97cTGYQ6gPp3UCeT/ZcElBfrGGAuD5u/ETXMJY7lqAZgYt
> K
> bELPv6oLhz3ya2IO442sUlRYO4dVfwhsnak+2rLiQkXCy4WKSJ1EYiMIP/VHj8ne
> 5e8VYkuc0KamKjvT4v6EwJ7tM0blfJbYgmFGruIxOSgCAo94Zp9thAcctb9PbRex
> HnPTcnw5cI1sCoLf5fJafhc9w/1H45WjJTnGF7zs4hq/GGsYCwryvI0ovwAzU9ST
> R3jRvE+70oiyQDsj9EBak63hRYIAd8QzQ3TkCjaM5E1XHSU7vTnxvxAjKb4ZyF4=
> =a8Vh
> -----END PGP SIGNATURE-----
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
