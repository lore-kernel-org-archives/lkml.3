Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab3GYTiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 15:38:00 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:46243
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757290Ab3GYTh4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 15:37:56 -0400
X-Forefront-Antispam-Report: CIP:198.70.193.115;KIP:(null);UIP:(null);IPV:NLI;H:avcashub1.qlogic.com;RD:avcashub1.qlogic.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zz9371I542I1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097hz2fh2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1155h)
From: Sony Chacko <sony.chacko@qlogic.com>
To: Greg KH <gregkh@linuxfoundation.org>,
        Rajesh Borundia <rajesh.borundia@qlogic.com>,
        Shahed Shaikh <shahed.shaikh@qlogic.com>,
        Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>,
        Dept-Eng Linux Driver <Linux-Driver@qlogic.com>
CC: netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: qlcnic binary sysfs file abuse
Thread-Topic: qlcnic binary sysfs file abuse
Thread-Index: AQHOeqj4K/uLYp7XaU+9RohCU6cBE5l15LRw
Date: Thu, 25 Jul 2013 19:37:46 +0000
Message-ID: <0EA5B226BC5C7B45A71BF612AA8A019E355A3BD4@AVMB1.qlogic.org>
References: <20130707002949.GA15822@kroah.com>
In-Reply-To: <20130707002949.GA15822@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.4.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: qlogic.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Saturday, July 06, 2013 5:30 PM
> To: Rajesh Borundia; Shahed Shaikh; Jitendra Kalsaria; Sony Chacko; Dept-Eng
> Linux Driver
> Cc: netdev; linux-kernel
> Subject: qlcnic binary sysfs file abuse
> 
> I was doing a kernel-wide audit on all of the binary sysfs files, and noticed a
> metric ton of them in the qlcnic driver.
> 
> So, any objection to me just deleting these entirely?  Or, if they really are
> needed, can I just move them to debugfs, which is where I think they should
> have been from the beginning?

Some applications are using these files, please move them to debugfs.

Thanks,
Sony


