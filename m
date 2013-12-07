Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403Ab3LGBTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 20:19:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34867 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab3LGBTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 20:19:51 -0500
Message-ID: <52A277A1.6000505@zytor.com>
Date: Fri, 06 Dec 2013 17:19:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "Ren, Qiaowei" <qiaowei.ren@intel.com>,
        "Liu, Jinsong" <jinsong.liu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Xudong Hao <xudong.hao@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Qemu-devel] [PATCH v2 3/3] X86,	mpx: Intel MPX xstate feature
 definition
References: <1386375658-2191-1-git-send-email-qiaowei.ren@intel.com>	<1386375658-2191-3-git-send-email-qiaowei.ren@intel.com> <52A20AD6.8080706@redhat.com> <DE8DF0795D48FD4CA783C40EC82923350140B3B6@SHSMSX101.ccr.corp.intel.com> <52A242BE.3010701@zytor.com> <DE8DF0795D48FD4CA783C40EC82923350140BB62@SHSMSX101.ccr.corp.intel.com> <9E0BE1322F2F2246BD820DA9FC397ADE014A6115@SHSMSX102.ccr.corp.intel.com> <52A274C0.4010509@zytor.com> <9E0BE1322F2F2246BD820DA9FC397ADE014A61BE@SHSMSX102.ccr.corp.intel.com>
In-Reply-To: <9E0BE1322F2F2246BD820DA9FC397ADE014A61BE@SHSMSX102.ccr.corp.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2013 05:16 PM, Ren, Qiaowei wrote:
> Jinsong think that both kvm and host depend on these feature definition header file, so we firstly submit these files depended on.

Yes, but we can't turn on the feature without proper protection.  Either
way, they are now in tip:x86/cpufeature.

	-hpa


