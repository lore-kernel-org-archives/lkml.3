Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab3FFUxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 16:53:25 -0400
Received: from usindpps04.hds.com ([207.126.252.17]:36900 "EHLO
	usindpps04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab3FFUxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 16:53:23 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "bp@alien8.de" <bp@alien8.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Subject: RE: [PATCH v14 3/3] trace,x86: Add irq vector tracepoints
Thread-Topic: [PATCH v14 3/3] trace,x86: Add irq vector tracepoints
Thread-Index: AQHOYsotQeDG6wpNaE25mf8kRIZYE5kpUq6AgAAL7ID//8qPEA==
Date: Thu, 6 Jun 2013 20:52:22 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41B03198C@USINDEM103.corp.hds.com>
References: <51B0A90F.7030309@hds.com> <51B0A9B4.4080703@hds.com>
	 <1370546299.9844.40.camel@gandalf.local.home>
 <1370548859.9844.41.camel@gandalf.local.home>
In-Reply-To: <1370548859.9844.41.camel@gandalf.local.home>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8626,1.0.431,0.0.0000
 definitions=2013-06-06_08:2013-06-06,2013-06-06,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 ipscore=0
 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1306060197
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r56KrXUU014382

Steven,

Thank you for reviewing.

I will create a patch just renaming variables and adding the is_debug_idt_enabled() and load_debug_idt().

Seiji

> -----Original Message-----
> From: Steven Rostedt [mailto:rostedt@goodmis.org]
> Sent: Thursday, June 06, 2013 4:01 PM
> To: Seiji Aguchi
> Cc: linux-kernel@vger.kernel.org; hpa@zytor.com; tglx@linutronix.de; mingo@elte.hu; bp@alien8.de; linux-edac@vger.kernel.org;
> tony.luck@intel.com; dle-develop@lists.sourceforge.net; Tomoki Sekiyama
> Subject: Re: [PATCH v14 3/3] trace,x86: Add irq vector tracepoints
> 
> On Thu, 2013-06-06 at 15:18 -0400, Steven Rostedt wrote:
> > On Thu, 2013-06-06 at 11:24 -0400, Seiji Aguchi wrote:
> 
> > Since we are basically down to cosmetic changes, can you make the
> > renames of these variables into a separate patch. As they are now more
> > about the debug IDT than a NMI idt, it should have been done before, and
> > is a separate change to what you are doing here.
> 
> I would even add the is_debug_idt_enabled() and load_debug_idt()
> interface to that patch as well.
> 
> -- Steve
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
