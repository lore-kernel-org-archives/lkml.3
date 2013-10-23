Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab3JWDt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 23:49:58 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:31077
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754343Ab3JWDt4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 23:49:56 -0400
From: Peter Guo <peter.guo@bayhubtech.com>
To: Chris Ball <cjb@laptop.org>
CC: Adrian Hunter <adrian.hunter@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>,
        "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Guan <samuel.guan@bayhubtech.com>,
        Xiaoguang Yu <xiaoguang.yu@bayhubtech.com>,
        Shirley Her <shirley.her@bayhubtech.com>,
        Yuxiang Wan <yuxiang.wan@bayhubtech.com>,
        "Adam Lee" <adam.lee@canonical.com>
Subject: RE: [PATCH v2] mmc:sdhci-pci: Add Support of O2Mirco/BayHubTech SD
 Host
Thread-Topic: [PATCH v2] mmc:sdhci-pci: Add Support of O2Mirco/BayHubTech SD
 Host
Thread-Index: AQHOykEE7eY8dOQvfEeK4nUJ9JKctZn2+0EAgAqwfmA=
Date: Wed, 23 Oct 2013 03:49:51 +0000
Message-ID: <ba51eef0193e40df9cf25b73af6890b6@BL2PR04MB083.namprd04.prod.outlook.com>
References: <97254cf7c23548fdbb3ebc10170af6a8@BL2PR04MB083.namprd04.prod.outlook.com>
 <20131016081532.GB3416@adam-laptop>
In-Reply-To: <20131016081532.GB3416@adam-laptop>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [27.17.7.178]
x-forefront-prvs: 000800954F
x-forefront-antispam-report: SFV:NSPM;SFS:(377454003)(13464003)(51704005)(24454002)(164054003)(189002)(199002)(46102001)(81686001)(74316001)(74706001)(81342001)(69226001)(83072001)(63696002)(54356001)(81542001)(66066001)(65816001)(74366001)(51856001)(53806001)(76482001)(80022001)(77982001)(59766001)(81816001)(83322001)(19580405001)(74876001)(19580395003)(79102001)(54316002)(56776001)(4396001)(50986001)(47976001)(47736001)(49866001)(47446002)(74502001)(74662001)(31966008)(80976001)(33646001)(85306002)(76576001)(76796001)(76786001)(77096001)(56816003)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR04MB177;H:BL2PR04MB083.namprd04.prod.outlook.com;CLIP:27.17.7.178;FPR:;RD:InfoNoRecords;MX:1;A:0;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: bayhubtech.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

Do you have any comments on this patch?

Thanks,
Peter.Guo

-----Original Message-----
From: Adam Lee [mailto:adam.lee@canonical.com] 
Sent: Wednesday, October 16, 2013 4:16 PM
To: Peter Guo; Chris Ball
Cc: Adrian Hunter; Greg Kroah-Hartman; Bill Pemberton; Guennadi Liakhovetski; linux-mmc@vger.kernel.org; linux-kernel@vger.kernel.org; Samuel Guan; Xiaoguang Yu; Shirley Her; Yuxiang Wan
Subject: Re: [PATCH v2] mmc:sdhci-pci: Add Support of O2Mirco/BayHubTech SD Host

On Wed, Oct 16, 2013 at 07:26:23AM +0000, Peter Guo wrote:
> Add O2Micro/BayHubTech SD Host DeviceId 8520 support and specified Init.
> Apply SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12 for SD Host Controller.
> Apply SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC for SD Host Controller.
> 
> Signed-off-by: peter.guo <peter.guo@bayhubtech.com>
> ---
>  drivers/mmc/host/sdhci-pci.c |  208 
> ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 208 insertions(+)

I'm enabling "O2 Micro, Inc. Device [1217:8520]" on some laptops, it works after this patch applied.

Chris, please take a look? Thanks.

Tested-by: Adam Lee <adam.lee@canonical.com>

--
Adam Lee
