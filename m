Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461Ab3HWWFS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 18:05:18 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:47257 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424Ab3HWWFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 18:05:15 -0400
MIME-Version: 1.0
In-Reply-To: <94F2FBAB4432B54E8AACC7DFDE6C92E36FED03C7@ORSMSX103.amr.corp.intel.com>
References: <20130822202158.GD3490@mtj.dyndns.org>
	<1377205598.10300.715.camel@misato.fc.hp.com>
	<20130822212111.GF3490@mtj.dyndns.org>
	<1377209861.10300.756.camel@misato.fc.hp.com>
	<20130823130440.GC10322@mtj.dyndns.org>
	<1377274448.10300.777.camel@misato.fc.hp.com>
	<521793BB.9080605@gmail.com>
	<CAE9FiQXZ610BrVaXoxY70NS3CaSku7mcVFx+x34-jpYUkG2rdQ@mail.gmail.com>
	<201308231825.r7NIPQl5015165@mail.zytor.com>
	<CAE9FiQVxQtpHp+0b1zFaA4YHx6hDiNSHKDveU=FzS5LwR80RmA@mail.gmail.com>
	<20130823203050.GB31817@sgi.com>
	<CAE9FiQU_JyJbYjpBQjfusc0=qjQjkA+2cxbVynEi_0mgKJFF4g@mail.gmail.com>
	<CAD11hGxm3K0sw885nH2QWb9N+5=q0qt+8trTAkUjzoejMepeTQ@mail.gmail.com>
	<94F2FBAB4432B54E8AACC7DFDE6C92E36FED03C7@ORSMSX103.amr.corp.intel.com>
Date: Fri, 23 Aug 2013 15:05:14 -0700
X-Google-Sender-Auth: uFDUVPqmOr3CdUg-oiLMSp0elEw
Message-ID: <CAE9FiQXy=nTOQ_=Ubx2jCyxm5hjuH43O7bG=DwXxC8SHcVLRkA@mail.gmail.com>
Subject: Re: [PATCH 0/8] x86, acpi: Move acpi_initrd_override() earlier.
From: Yinghai Lu <yinghai@kernel.org>
To: "Moore, Robert" <robert.moore@intel.com>, Russ Anderson <rja@sgi.com>
Cc: chen tang <imtangchen@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Toshi Kani <toshi.kani@hp.com>, Tejun Heo <tj@kernel.org>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Zheng, Lv" <lv.zheng@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 2:52 PM, Moore, Robert <robert.moore@intel.com> wrote:
> While we're at it:
>
> Can someone send me the acpidump for this machine? We very much would like to test all of ACPICA with such a large DSDT.

That is Russ.
