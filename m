Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbaGWESO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 00:18:14 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:46543 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752157AbaGWESM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 00:18:12 -0400
From: Mohit KUMAR DCG <Mohit.KUMAR@st.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Date: Wed, 23 Jul 2014 12:17:52 +0800
Subject: RE: [PATCH v3 0/4] dra7: Add PCIe support
Thread-Topic: [PATCH v3 0/4] dra7: Add PCIe support
Thread-Index: Ac+l9IwTWAfjs1UYSJ+DUnZWGai0rQAODqag
Message-ID: <2CC2A0A4A178534D93D5159BF3BCB661A61189AF02@EAPEX1MAIL1.st.com>
References: <1405587643-13808-1-git-send-email-kishon@ti.com>
 <20140722213306.GB25432@google.com>
In-Reply-To: <20140722213306.GB25432@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-23_01:2014-07-22,2014-07-23,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Bjorn,

> -----Original Message-----
> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
> Sent: Wednesday, July 23, 2014 3:03 AM
> To: Kishon Vijay Abraham I
> Cc: devicetree@vger.kernel.org; linux-doc@vger.kernel.org; linux-
> pci@vger.kernel.org; jg1.han@samsung.com; Mohit KUMAR DCG; linux-
> kernel@vger.kernel.org; grant.likely@linaro.org
> Subject: Re: [PATCH v3 0/4] dra7: Add PCIe support
> 
> On Thu, Jul 17, 2014 at 02:30:39PM +0530, Kishon Vijay Abraham I wrote:
> > Changes from v2:
> > * Added myself as MAINTAINER of pcie dra7xx driver

[...]

> 
> I applied these to pci/host-designware for v3.17.  This will not be in my first
> pull request because I'm going on vacation and won't have time to get
> everything through -next and tagged.  But I'm planning a second pull request
> that will include this.
> 
> Mohit, I applied your ack of "use untranslated address" from the v1 posting
> (your mail of Jul 09) to the corresponding patch here, since Kishon didn't
> carry it forward.  Let me know if that's not OK.

- yes, OK with me. 

Thanks
Mohit
> 
> I also squashed the last two patches into one so the DT binding
> documentation goes along with the dra7xx driver addition.
> 
> Bjorn
