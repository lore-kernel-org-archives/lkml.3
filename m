Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404AbaGCE05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 00:26:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:37282 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbaGCE0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 00:26:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,592,1400050800"; 
   d="scan'208";a="564515179"
From: "Liang, Kan" <kan.liang@intel.com>
To: Jidong Xiao <jidong.xiao@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>, "andi@firstfloor.org" <andi@firstfloor.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: RE: [PATCH V2 1/3] perf ignore LBR and offcore_rsp.
Thread-Topic: [PATCH V2 1/3] perf ignore LBR and offcore_rsp.
Thread-Index: AQHPlmMa2+E29q6Tk0SWaq86jnLk6JuNGj0AgACZg9A=
Date: Thu, 3 Jul 2014 04:26:51 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F077014BDCCD@SHSMSX103.ccr.corp.intel.com>
References: <1404324855-15166-1-git-send-email-kan.liang@intel.com>
 <CAG4AFWboxFM7g+RL+ACawOWATHnPxG0omnfgV4DZaVBu=BzDTg@mail.gmail.com>
In-Reply-To: <CAG4AFWboxFM7g+RL+ACawOWATHnPxG0omnfgV4DZaVBu=BzDTg@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s634R1LE004634



> 
> On Wed, Jul 2, 2014 at 2:14 PM,  <kan.liang@intel.com> wrote:
> > From: Kan Liang <kan.liang@intel.com>
> >
> > x86, perf: Protect LBR and offcore rsp against KVM lying
> >
> > With -cpu host, KVM reports LBR and offcore support, if the host has
> support.
> > When the guest perf driver tries to access LBR or offcore_rsp MSR, it
> > #GPs all MSR accesses,since KVM doesn't handle LBR and offcore support.
> > So check the related MSRs access right once at initialization time to avoid
> the error access at runtime.
> >
> > For reproducing the issue, please build the kernel with
> CONFIG_KVM_INTEL = y.
> This is for host kernel,
> > And CONFIG_PARAVIRT = n and CONFIG_KVM_GUEST = n.
> And this is for guest kernel, right?
> 

Right.


> -Jidong
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
