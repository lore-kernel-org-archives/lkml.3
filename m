Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab3DVQnd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 12:43:33 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:30805
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753028Ab3DVQnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 12:43:32 -0400
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT004.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: PS-5(zzbb2dI98dI9371I936eI1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275dhz2fh2a8h668h839h93fhd24he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Jiri Slaby <jslaby@suse.cz>
CC: Matt Fleming <matt@console-pimps.org>, joeyli <jlee@suse.com>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        Tony Luck <tony.luck@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Cannot add new efi boot entry
Thread-Topic: Cannot add new efi boot entry
Thread-Index: AQHOOVacfIOhDacBfk6nkcHsTUzbI5jYno4AgAAEKYCAAdp1AIAABj0AgAHJGgCAAnV2gIADXnGAgAAGt4CAAA3bgIAAAToAgABIHwA=
Date: Mon, 22 Apr 2013 16:43:25 +0000
Message-ID: <1366649004.13667.23.camel@x230.lan>
References: <516B1ED3.9040900@suse.cz>
	  <1366106168.23707.9.camel@linux-s257.site> <516D23B5.4070209@intel.com>
	  <516EB1B6.7050506@suse.cz> <516EB6F2.6070806@console-pimps.org>
	  <51703664.40003@suse.cz> <5172466B.9080105@suse.cz>
	  <517519E3.2030409@console-pimps.org>
	 <1366630277.23707.132.camel@linux-s257.site>
	 <51752B25.9020809@console-pimps.org> <51752C2C.4090707@suse.cz>
In-Reply-To: <51752C2C.4090707@suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <434B760AE3EEBA44AC089CE3024DF7EB@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3MGhdnU007121

On Mon, 2013-04-22 at 14:25 +0200, Jiri Slaby wrote:
> On 04/22/2013 02:20 PM, Matt Fleming wrote:
> > On 22/04/13 12:31, joeyli wrote:
> >> Does garbage collection only trigger by UEFI BIOS when system reboot? or
> >> garbage collection also triggered at run time?
> > 
> > That is implementation specific. AFAIK, there are implementations for
> > both schemes.
> 
> Just a point from the abstract level. Is there a way to find out? And
> what do Windows do?

Windows kills Samsungs.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
