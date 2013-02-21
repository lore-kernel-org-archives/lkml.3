Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab3BUVnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 16:43:41 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:51356
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753022Ab3BUVnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 16:43:39 -0500
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT005.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: PS-2(zz98dI936eIzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2fh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Benson Leung <bleung@chromium.org>
CC: "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "olofj@chromium.org" <olofj@chromium.org>,
        "miletus@chromium.org" <miletus@chromium.org>
Subject: Re: [PATCH 1/6] Platform: x86: chromeos_laptop - add i915 gmbuses
 to adapter names
Thread-Topic: [PATCH 1/6] Platform: x86: chromeos_laptop - add i915 gmbuses
 to adapter names
Thread-Index: AQHOEHArF5u30YXwvUqVKUfplRv0q5iE2BqA
Date: Thu, 21 Feb 2013 21:43:32 +0000
Message-ID: <1361483011.2813.1.camel@x230>
References: <1361477700-26342-1-git-send-email-bleung@chromium.org>
	 <1361477700-26342-2-git-send-email-bleung@chromium.org>
In-Reply-To: <1361477700-26342-2-git-send-email-bleung@chromium.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <AE8BCBB5CE37D040B344E0C7449E0920@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1LLhglU012354

On Thu, 2013-02-21 at 12:14 -0800, Benson Leung wrote:
> Add the two other i2c buses (vga and panel) from i915.
> Chromebook Pixel has input and light sensor devices on these busses.

This is after you put the HDMI encoder on the system i2c bus on the
CR-48? Whatever they're putting in the food there must be good. I'll
queue these.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
