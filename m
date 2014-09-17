Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbaIQEzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 00:55:17 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:41800 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750985AbaIQEzP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 00:55:15 -0400
From: Mohit KUMAR DCG <Mohit.KUMAR@st.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Fabio Estevam <festevam@gmail.com>
Cc: "matwey@sai.msu.ru" <matwey@sai.msu.ru>, Jingoo Han <jg1.han@samsung.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "matwey.kornilov@gmail.com" <matwey.kornilov@gmail.com>
Date: Wed, 17 Sep 2014 12:54:51 +0800
Subject: RE: [PATCH] Export functions from pcie-designware
Thread-Topic: [PATCH] Export functions from pcie-designware
Thread-Index: Ac/SB11VfZpxpTKVRQCReWAVNzO1YgAKOnFQ
Message-ID: <2CC2A0A4A178534D93D5159BF3BCB661ABCD7BCF19@EAPEX1MAIL1.st.com>
References: <1409401476-5002-1-git-send-email-matwey@sai.msu.ru>
 <CAOMZO5DzNo3Y6=R4mA=h0+RjWoM6UBCqXxqeEqUM4iu5RjrBEA@mail.gmail.com>
 <20140916233841.GJ5050@google.com>
In-Reply-To: <20140916233841.GJ5050@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-17_02:2014-09-16,2014-09-17,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Bjorn,

> -----Original Message-----
> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
> Sent: Wednesday, September 17, 2014 5:09 AM
> To: Fabio Estevam
> Cc: matwey@sai.msu.ru; Mohit KUMAR DCG; Jingoo Han; linux-
> pci@vger.kernel.org; linux-kernel; matwey.kornilov@gmail.com
> Subject: Re: [PATCH] Export functions from pcie-designware
> 
> On Sat, Aug 30, 2014 at 10:07:30AM -0300, Fabio Estevam wrote:
> > On Sat, Aug 30, 2014 at 9:24 AM,  <matwey@sai.msu.ru> wrote:
> > > From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
> > >
> > > pcie-spear13xx when built as module requires the functions from pcie-
> designware.
> > > Export them properly.
> 
> I don't know how valuable pcie-spear13xx as a module is.  No other host
> drivers are supported as a module.  Maybe we should just change pcie-
> spear13xx from tristate to bool?
> 
-  Sachin's patch is already doing this:
http://www.spinics.net/lists/linux-pci/msg33665.html

You acknowledge it to apply for v3.17 but somehow it has been left out.

Regards
Mohit

