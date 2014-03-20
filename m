Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160AbaCTLvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 07:51:53 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:27686 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082AbaCTLvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 07:51:51 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-60-532ad65405fa
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Pratyush Anand <pratyush.anand@st.com>
Cc: Tejun Heo <tj@kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@gmail.com>,
        Mohit Kumar <mohit.kumar@st.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCH 4/4] ata: add new-style AHCI platform driver for ST
 SPEAr1340 AHCI controller
Date: Thu, 20 Mar 2014 12:51:32 +0100
Message-id: <3482323.3pWPcG8rCe@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <20140320085717.GC4607@pratyush-vbox>
References: <1395081118-15248-1-git-send-email-b.zolnierkie@samsung.com>
 <1395081118-15248-5-git-send-email-b.zolnierkie@samsung.com>
 <20140320085717.GC4607@pratyush-vbox>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsVy+t9jQd3Qa1rBBm/FLP5OOsZuce5WA6vF
	nRXMFpseX2O1OLbjEZPF5V1z2Cw2Tv3FaLG/dwOTRfslZYs/H/Qs5szYzGrxa/lRRouVF/8y
	O/B6/P41idHj+qv/TB47Z91l99i0qpPNY860JhaPkxdOsnhsXlLv8fTHXmaP4ze2M3l83iQX
	wBXFZZOSmpNZllqkb5fAlbFo70WmgntsFdeWtTE1MG5n7WLk5JAQMJG4Ou0lO4QtJnHh3nq2
	LkYuDiGB6YwSe9sfsUM4LUwS667MZAGpYhOwkpjYvooRxBYR0JJ4tmMRWAezwF0WiTu9B8HG
	CgskSzQd6QcrYhFQlbi/4DkziM0roCnx98s9JhBbVMBTYsf2lWwgNqeAkcTSzh2sENvWM0qc
	7HjLDtEgKPFj8j2wzcwC8hL79k9lhbC1JNbvPM40gVFgFpKyWUjKZiEpW8DIvIpRNLUguaA4
	KT3XSK84Mbe4NC9dLzk/dxMjOJ6eSe9gXNVgcYhRgINRiYd3xR7NYCHWxLLiytxDjBIczEoi
	vEsuawUL8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Yah0oJJCeWJKanZpakFoEk2Xi4JRqYGxv
	uRLacvyoTEZAfU/bl/BcPZVpx5iao36da3y8Vs8oatbhPt/ENVc5nkqefFNuk5CxLmn7zW1v
	Nf6qFHj9fnpn3oU38jkee6weTM87fZ4l2P+rZZdjrFhlho9s7urw/qt/zxgy7JvT/v1QUQfz
	BqbWB7MNFVcvKlytVRGcxd52qMbh5FRjbSWW4oxEQy3mouJEANcyOM+jAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday, March 20, 2014 02:27:17 PM Pratyush Anand wrote:
> On Tue, Mar 18, 2014 at 02:31:58AM +0800, Bartlomiej Zolnierkiewicz wrote:
> > The new driver is named ahci_spear1340 and is only compile tested.  Once
> > it is tested on the real hardware and verified to work correctly, the legacy
> > platform code (which depends on the deprecated struct ahci_platform_data)
> > can be removed.
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> 
> This patch will not be needed any more, since SPEAr sata platform code has
> already been cleaned up.
> 
> See:
> https://lkml.org/lkml/2014/2/28/174

OK.  Conversion of SPEAr1340 AHCI platform code to PHY driver is even better
than adding custom AHCI driver.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

