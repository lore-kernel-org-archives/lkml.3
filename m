Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab3EJNIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 09:08:54 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:9157 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751247Ab3EJNIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 09:08:52 -0400
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT003.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: PS-6(zz98dI936eI1432I13e6Kzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2fh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "Ren, Qiaowei" <qiaowei.ren@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "Wei, Gang" <gang.wei@intel.com>
Subject: Re: [PATCH 4/4] driver: provide sysfs interfaces to access SMX
 parameter
Thread-Topic: [PATCH 4/4] driver: provide sysfs interfaces to access SMX
 parameter
Thread-Index: AQHOSvE+ysMfIHdI9EqG5gcExdaKwpj6wt+AgAMpG0CAAHzgAA==
Date: Fri, 10 May 2013 13:07:48 +0000
Message-ID: <1368191268.2425.38.camel@x230>
References: <1367938519-840-1-git-send-email-qiaowei.ren@intel.com>
	 <1367938519-840-5-git-send-email-qiaowei.ren@intel.com>
	 <1367990697.2425.33.camel@x230>
	 <9E0BE1322F2F2246BD820DA9FC397ADE9AC926@SHSMSX102.ccr.corp.intel.com>
In-Reply-To: <9E0BE1322F2F2246BD820DA9FC397ADE9AC926@SHSMSX102.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <AFB5317BDD6C60488F441B16A9F44B58@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4AD8wtm022024

On Fri, 2013-05-10 at 07:05 +0000, Ren, Qiaowei wrote:
> On 2013-05-08, Matthew Garrett wrote:
> > On Tue, 2013-05-07 at 22:55 +0800, Qiaowei Ren wrote:
> >
> > > +What:		/sys/devices/platform/intel_txt/parameter/acm_max_size
> > > +Date:		May 2013
> > > +KernelVersion:	3.9
> > > +Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
> > > +Description:	The "acm_max_size" property will show max size of
> > > +		authenticated code execution area.
> > 
> > What would userspace use this for?
> 
> These sysfs files are just export SMX & TXT related information to userspace. So that other developers (or OSV & ISV) can be able to develop txt related applications or tools based on these information.

If they're only using it for debugging purposes then sysfs probably
isn't the right place. Is there any reason tools would need to know this
during normal usage?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
