Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193Ab3DARr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 13:47:57 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:53792
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755818Ab3DARr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 13:47:56 -0400
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT002.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: PS-1(z551biz98dI936eIzz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dh8275bhz2fh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: =?utf-8?B?TWFudGFzIE1pa3VsxJduYXM=?= <grawity@gmail.com>,
        Dave Airlie <airlied@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        "skeggsb@gmail.com" <skeggsb@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Murphy <bugzilla@colorremedies.com>
Subject: Re: [PATCH 1/3] pci: Add PCI ROM helper for platform-provided ROM
 images
Thread-Topic: [PATCH 1/3] pci: Add PCI ROM helper for platform-provided ROM
 images
Thread-Index: AQHOKmiXOpHZUO4GF0K7XGZOkZTUk5i4lI2AgAAAxQCAAWqsgIAAzU2AgAbdmQCAAAJUAA==
Date: Mon, 1 Apr 2013 17:47:47 +0000
Message-ID: <1364838466.19098.1.camel@x230>
References: <CAPM=9tyYMSsK_2eCNRTx5EsgAQtnvmHxhgPHP3GHPxKUn+wo5w@mail.gmail.com>
	 <1364333156-4530-1-git-send-email-matthew.garrett@nebula.com>
	 <CAErSpo7fy+MVxDoLe6w+4noH5X2xJw_Lfdg6fVvgcbhgvUyAaw@mail.gmail.com>
	 <1364338554.2553.53.camel@x230.sbx07502.somerma.wayport.net>
	 <CAErSpo7ZYMsRAp=EKMS0YPmiw6YytN4pZVzoWPd-PL5EzT8+SQ@mail.gmail.com>
	 <515403ED.6010008@gmail.com>
	 <CAErSpo6T5KmTcm2fnoQZvSpJjzXozRd4AVL9REjn6gsL9Q1uPw@mail.gmail.com>
In-Reply-To: <CAErSpo6T5KmTcm2fnoQZvSpJjzXozRd4AVL9REjn6gsL9Q1uPw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <49EC97E49C723A4489AC98E360196970@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r31Hm2EX011439

On Mon, 2013-04-01 at 11:39 -0600, Bjorn Helgaas wrote:

> Chris still has problems (see
> https://bugzilla.redhat.com/show_bug.cgi?id=927451), but I don't know
> whether they are related to these patches or something else.

I think they're unrelated. The log he posts using this patch gives the
correct output - the ROM image comes from the platform method rather
than from PCI. I think Ben probably needs to look at that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
