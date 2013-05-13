Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab3EMRbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 13:31:45 -0400
Received: from mail-db8lp0184.outbound.messaging.microsoft.com ([213.199.154.184]:9858
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751831Ab3EMRbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 13:31:43 -0400
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT004.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: PS-2(zz98dI936eIzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275dhz2fh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Qiaowei Ren <qiaowei.ren@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        Xiaoyan Zhang <xiaoyan.zhang@intel.com>, Gang Wei <gang.wei@intel.com>
Subject: Re: [PATCH v2 1/3] driver: add TXT driver in kernel
Thread-Topic: [PATCH v2 1/3] driver: add TXT driver in kernel
Thread-Index: AQHOT70b+pkxt2HUd02MaXTvFOnXWZkDX/UA
Date: Mon, 13 May 2013 17:31:36 +0000
Message-ID: <1368466296.2425.48.camel@x230>
References: <1368465884-14779-1-git-send-email-qiaowei.ren@intel.com>
	 <1368465884-14779-2-git-send-email-qiaowei.ren@intel.com>
In-Reply-To: <1368465884-14779-2-git-send-email-qiaowei.ren@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <B165269915163B4482E947933A2776F6@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4DHVoVZ002417

On Tue, 2013-05-14 at 01:24 +0800, Qiaowei Ren wrote:
> static int __init txt_sysfs_init(void)
> +{
> +	if (!tboot_enabled())
> +		return -ENODEV;

If there's a CPU flag that indicates tboot support, you should add a
modalias for it in order to ensure that the module gets automatically
loaded.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
