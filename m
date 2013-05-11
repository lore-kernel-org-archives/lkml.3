Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab3EKUWW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 16:22:22 -0400
Received: from mail-db8lp0185.outbound.messaging.microsoft.com ([213.199.154.185]:28726
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753879Ab3EKUWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 16:22:20 -0400
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT005.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: PS-5(zz98dI9371I936eI1432Idf9Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275dhz2fh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Emmanuel Grumbach <egrumbach@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        John Linville <linville@tuxdriver.com>,
        Roman Yepishev <roman.yepishev@gmail.com>,
        "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Mike Miller <mike.miller@hp.com>,
        "iss_storagedev@hp.com" <iss_storagedev@hp.com>,
        Guo-Fu Tseng <cooldavid@cooldavid.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "nic_swsd@realtek.com" <nic_swsd@realtek.com>,
        "aacraid@adaptec.com" <aacraid@adaptec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: is L1 really disabled in iwlwifi
Thread-Topic: is L1 really disabled in iwlwifi
Thread-Index: AQHORfSKftx1y5ISNk+G0CEFeiZmAZjvX74AgACg4YCAAJHNgIAOg+SAgAFphoD///6uAA==
Date: Sat, 11 May 2013 20:22:11 +0000
Message-ID: <1368303730.2425.47.camel@x230>
References: <CANUX_P2Hy02SnyYS24dyUGLv3wB3L5xkXt8Y1s+8_RG9d5ReAw@mail.gmail.com>
	 <CAErSpo6OCyTy19u6Xaf=xr0TSDriwCD3n-oMc7eJyLzuJ9d60g@mail.gmail.com>
	 <20130510225257.GA10847@google.com> <1725435.3DlCxYF2FV@vostro.rjw.lan>
In-Reply-To: <1725435.3DlCxYF2FV@vostro.rjw.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <F6E1D67B19D3AB43BF0EDA44E514F21E@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4BKMTKu027420

On Sat, 2013-05-11 at 22:26 +0200, Rafael J. Wysocki wrote:
> On Friday, May 10, 2013 04:52:57 PM Bjorn Helgaas wrote:
> > I propose the following patch.  Any comments?
> 
> In my opinion this is dangerous, because it opens us to bugs that right now
> are prevented from happening due to the way the code works.

Right, I'm also not entirely comfortable with this. The current
behaviour may be confusing, but we could reduce that by renaming the
functions. I'm still not clear on whether anyone's actually seeing
problems caused by the existing behaviour.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
