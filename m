Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbaHKIyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:54:24 -0400
Received: from mx0.aculab.com ([213.249.233.131]:52439 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752580AbaHKIyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:54:20 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Mathias Nyman'" <mathias.nyman@linux.intel.com>,
        Julius Werner <jwerner@chromium.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>
CC: Maciej Puzio <mx34567@gmail.com>, Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] usb: xhci: Fix Set TR Dequeue Pointer cycle state for
 quirky xHCs
Thread-Topic: [PATCH] usb: xhci: Fix Set TR Dequeue Pointer cycle state for
 quirky xHCs
Thread-Index: AQHPp0ZkVkDSwZ/t0EWXkV2roFJKzZvLNFSA
Date: Mon, 11 Aug 2014 08:52:34 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1747473D@AcuExch.aculab.com>
References: <CACH_MLWEYRaT8RPHw-tdBBJoey283w1ED_QY6yXMiqYO5pjROg@mail.gmail.com>
	<CAODwPW-x3RmQ95Zs0HKYkqOUN9G+r-mueW4d9G+x7qZGhctwRw@mail.gmail.com>
	<CACH_MLVpnfJjQSEf3xqF_KQzsi=E=M=Fz2khEqajg7FdNR0x_g@mail.gmail.com>
	<CAODwPW9UUGYzK3-83+PNXWKP4M5H=8GmYBjrgvW2Kg6nA6ssrw@mail.gmail.com>
	<063D6719AE5E284EB5DD2968C1650D6D1726E25E@AcuExch.aculab.com>
	<1404846104-4959-1-git-send-email-jwerner@chromium.org>
	<CACH_MLUEKbFtrN2vMHdVEpJFJ=e9adEyU=OwPMh5TcrUuRQPHw@mail.gmail.com>
	<A2CA0424C0A6F04399FB9E1CD98E0304844BF057@US01WEMBX2.internal.synopsys.com>
 <CAODwPW_o5=Cf7W1=7zBQnNs2kQLKsQLm93BAAgd00=MeRXoH_g@mail.gmail.com>
 <53D11293.7050606@linux.intel.com>
In-Reply-To: <53D11293.7050606@linux.intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7B8sS2e006132

> It's starting to get a bit too complicated.
> xhci find_new_dequeue_state() now has four places where it can toggle the cycle bit
> in addition to the cycle toggle in find_trb_seg().
> 
> In the end we really just want to do it max once.
> 
> I'll see if I can simplify the whole cycle bit code somehow.

Have a look at the patches I submitted last year.
I remember simplifying a lot of that code.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
