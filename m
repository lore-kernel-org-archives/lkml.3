Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab3CZW4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:56:01 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:41563
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756506Ab3CZWz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:55:58 -0400
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT004.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: PS-2(z551biz98dI936eI154dIzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dh8275bhz2fh2a8h668h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Dave Airlie <airlied@gmail.com>, Alex Deucher <alexander.deucher@amd.com>,
        "skeggsb@gmail.com" <skeggsb@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        "grawity@gmail.com" <grawity@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/3] pci: Add PCI ROM helper for platform-provided ROM
 images
Thread-Topic: [PATCH 1/3] pci: Add PCI ROM helper for platform-provided ROM
 images
Thread-Index: AQHOKmiXOpHZUO4GF0K7XGZOkZTUk5i4lI2AgAAAxQA=
Date: Tue, 26 Mar 2013 22:55:54 +0000
Message-ID: <1364338554.2553.53.camel@x230.sbx07502.somerma.wayport.net>
References: <CAPM=9tyYMSsK_2eCNRTx5EsgAQtnvmHxhgPHP3GHPxKUn+wo5w@mail.gmail.com>
	 <1364333156-4530-1-git-send-email-matthew.garrett@nebula.com>
	 <CAErSpo7fy+MVxDoLe6w+4noH5X2xJw_Lfdg6fVvgcbhgvUyAaw@mail.gmail.com>
In-Reply-To: <CAErSpo7fy+MVxDoLe6w+4noH5X2xJw_Lfdg6fVvgcbhgvUyAaw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <0B368E204FE557439A8CAD5FF57AFF90@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2QMu4nA007978

On Tue, 2013-03-26 at 16:53 -0600, Bjorn Helgaas wrote:

> I've been on vacation and didn't follow this closely, but it seems
> like this fixes a regression and should be merged before v3.9, right?
> Can you include a reference to a bugzilla or the mailing list
> discussion in the changelog?  I can just fold it in if you want.

https://bugzilla.redhat.com/show_bug.cgi?id=927451

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
