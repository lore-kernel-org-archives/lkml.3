Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965545AbaDJH7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 03:59:51 -0400
Received: from gws07.hcl.com ([192.8.186.130]:56879 "EHLO GWS07.hcl.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965148AbaDJH7s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 03:59:48 -0400
X-IronPort-AV: E=Sophos;i="4.97,832,1389724200"; 
   d="scan'208";a="19850735"
From: Narasimharao Bolisetti <narasimharao.b@hcl.com>
To: Willy Tarreau <w@1wt.eu>, narasimharo bolisetti <nrbolisetti@yahoo.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernelnewbies@nl.linux.org" <kernelnewbies@nl.linux.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-hotplug@vger.kernel.org" <linux-hotplug@vger.kernel.org>,
        "greg@kroah.com" <greg@kroah.com>,
        "nrbolisetti@gmail.com" <nrbolisetti@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: system hang
Thread-Topic: system hang
Thread-Index: Ac9TxoeCbQhyr4aBTOyERW9oKhui6gAt7sJQ//+95QCAAA3pgP//ovZw
Date: Thu, 10 Apr 2014 07:59:38 +0000
Message-ID: <62C418AB752FEF4D931AB8E89E46539F02878EC8@chn-hclt-mbs06.HCLT.CORP.HCL.IN>
References: <62C418AB752FEF4D931AB8E89E46539F02878DFC@chn-hclt-mbs06.HCLT.CORP.HCL.IN>
 <1397113552.75117.YahooMailBasic@web160504.mail.bf1.yahoo.com>
 <20140410075539.GB25198@1wt.eu>
In-Reply-To: <20140410075539.GB25198@1wt.eu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.150.5.114]
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I have checked the same in the recent kernel versions also. Issue is still remain.

Regards,
Narasimharao B


-----Original Message-----
From: Willy Tarreau [mailto:w@1wt.eu] 
Sent: 10 April 2014 13:26
To: narasimharo bolisetti
Cc: linux-kernel@vger.kernel.org; kernelnewbies@nl.linux.org; devel@linuxdriverproject.org; linux-serial@vger.kernel.org; linux-hotplug@vger.kernel.org; greg@kroah.com; Narasimharao Bolisetti; nrbolisetti@gmail.com; stable@vger.kernel.org; linux-pci@vger.kernel.org; linux-usb@vger.kernel.org
Subject: Re: system hang

On Thu, Apr 10, 2014 at 12:05:52AM -0700, narasimharo bolisetti wrote:
>  My kernel version is:
>  2.6.35.6-45.fc14.i686

Maintenance for this kernel has been dropped years ago, so it very likely contains many bugs that were fixed in more recent ones. You should definitely upgrade.

Hoping this helps,
Willy



::DISCLAIMER::
----------------------------------------------------------------------------------------------------------------------------------------------------

The contents of this e-mail and any attachment(s) are confidential and intended for the named recipient(s) only.
E-mail transmission is not guaranteed to be secure or error-free as information could be intercepted, corrupted,
lost, destroyed, arrive late or incomplete, or may contain viruses in transmission. The e mail and its contents
(with or without referred errors) shall therefore not attach any liability on the originator or HCL or its affiliates.
Views or opinions, if any, presented in this email are solely those of the author and may not necessarily reflect the
views or opinions of HCL or its affiliates. Any form of reproduction, dissemination, copying, disclosure, modification,
distribution and / or publication of this message without the prior written consent of authorized representative of
HCL is strictly prohibited. If you have received this email in error please delete it and notify the sender immediately.
Before opening any email and/or attachments, please check them for viruses and other defects.

----------------------------------------------------------------------------------------------------------------------------------------------------

