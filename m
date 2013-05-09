Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab3EIMD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 08:03:29 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:58141
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752400Ab3EIMD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 08:03:27 -0400
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT002.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: PS-3(zz98dI936eI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275dhz2fh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "Ren, Qiaowei" <qiaowei.ren@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>
Subject: Re: [PATCH 0/4] Intel TXT driver
Thread-Topic: [PATCH 0/4] Intel TXT driver
Thread-Index: AQHOS5PFmBce6mwNH02tr7833obeppj8hMyAgAA+QIA=
Date: Thu, 9 May 2013 12:02:39 +0000
Message-ID: <1368100959.2425.37.camel@x230>
References: <1367938519-840-1-git-send-email-qiaowei.ren@intel.com>
	 <1367980128.2425.3.camel@x230>
	 <9E0BE1322F2F2246BD820DA9FC397ADE9AAC26@SHSMSX102.ccr.corp.intel.com>
In-Reply-To: <9E0BE1322F2F2246BD820DA9FC397ADE9AAC26@SHSMSX102.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D0172FF5546CBF468BC3F1D610C5C74E@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r49C3Y2a014995

On Thu, 2013-05-09 at 08:19 +0000, Ren, Qiaowei wrote:
> On 2013-05-08, Matthew Garrett wrote:
> > On Tue, 2013-05-07 at 22:55 +0800, Qiaowei Ren wrote:
> >> This module is expected to be a better tool to access below resources
> >>   - TXT config space
> >>   - Tboot log mem
> >>   - SMX parameter
> > 
> > What's SMX?
> 
> Safer Mode Extensions (SMX) provide a programming interface for system software to establish a measured environment within the platform to support trust decisions by end users. SMX functionality is provided in an Intel 64 processor through the GETSEC instruction via leaf functions.

Great. Can you include that in the patches and help text?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
