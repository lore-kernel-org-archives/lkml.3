Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab3LFPzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 10:55:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:13898 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526Ab3LFPzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 10:55:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,841,1378882800"; 
   d="scan'208";a="445805675"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: Paolo Bonzini <pbonzini@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Xudong Hao" <xudong.hao@intel.com>,
        "Liu, Jinsong" <jinsong.liu@intel.com>
Subject: RE: [PATCH 1/3] x86, mpx: add documentation on Intel MPX
Thread-Topic: [PATCH 1/3] x86, mpx: add documentation on Intel MPX
Thread-Index: AQHO8neZfx07qtPJJki+2rKfZdg4T5pGopUAgACswDA=
Date: Fri, 6 Dec 2013 15:55:10 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE014A4322@SHSMSX102.ccr.corp.intel.com>
References: <1386355976-11732-1-git-send-email-qiaowei.ren@intel.com>
 <20131206132648.GB6694@pd.tnic>
In-Reply-To: <20131206132648.GB6694@pd.tnic>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rB6FtPlV020184



> -----Original Message-----
> From: Borislav Petkov [mailto:bp@alien8.de]
> Sent: Friday, December 06, 2013 9:27 PM
> To: Ren, Qiaowei
> Cc: Paolo Bonzini; H. Peter Anvin; Ingo Molnar; Thomas Gleixner;
> x86@kernel.org; linux-kernel@vger.kernel.org; qemu-devel@nongnu.org;
> kvm@vger.kernel.org; Xudong Hao; Liu, Jinsong
> Subject: Re: [PATCH 1/3] x86, mpx: add documentation on Intel MPX
> 
> On Sat, Dec 07, 2013 at 02:52:54AM +0800, Qiaowei Ren wrote:
> > This patch adds the Documentation/intel_mpx.txt file with some
> > information about Intel MPX.
> >
> > Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> > Signed-off-by: Xudong Hao <xudong.hao@intel.com>
> > Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
> > ---
> >  Documentation/intel_mpx.txt |   77
> +++++++++++++++++++++++++++++++++++++++++++
> 
> Documentation/x86/ is probably a more fitting place for this.
> 
Yes. I will move it to Documentation/x86.

> >  1 files changed, 77 insertions(+), 0 deletions(-)  create mode 100644
> > Documentation/intel_mpx.txt
> >
> > diff --git a/Documentation/intel_mpx.txt b/Documentation/intel_mpx.txt
> > new file mode 100644 index 0000000..3d947d0
> > --- /dev/null
> > +++ b/Documentation/intel_mpx.txt
> > @@ -0,0 +1,77 @@
> > +Intel(R) MPX Overview:
> > +=====================
> > +
> > +Intel(R) Memory Protection Extensions (Intel(R) MPX) is a new
> > +capability introduced into Intel Architecture. Intel MPX can increase
> > +the robustness of software when it is used in conjunction with
> > +compiler changes to check memory references, for those references
> > +whose compile-time normal intentions are usurped
> 
> That's a strange formulation, what does it actually mean? The intentions of
> references??
> 
It is from public introduction and specification, you can refer to http://software.intel.com/en-us/articles/introduction-to-intel-memory-protection-extensions 

Thanks,
Qiaowei
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
