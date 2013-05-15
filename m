Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544Ab3EOQZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 12:25:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60570 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758243Ab3EOQZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 12:25:46 -0400
Message-ID: <5193B6CB.5080301@zytor.com>
Date: Wed, 15 May 2013 09:24:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Wei, Gang" <gang.wei@intel.com>
CC: "Ren, Qiaowei" <qiaowei.ren@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tboot-devel@lists.sourceforge.net" 
	<tboot-devel@lists.sourceforge.net>
Subject: Re: [PATCH] x86: add a new SMP bring up way for tboot case
References: <1368566485-14785-1-git-send-email-qiaowei.ren@intel.com> <519257FC.8070708@zytor.com> <9E0BE1322F2F2246BD820DA9FC397ADE9B851C@SHSMSX102.ccr.corp.intel.com> <7877c9de-aa56-4f66-9e51-97987e34cc39@email.android.com> <D0B11485C64D4B47B66902F8A4E901BEAD5592@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <D0B11485C64D4B47B66902F8A4E901BEAD5592@SHSMSX101.ccr.corp.intel.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2013 09:10 AM, Wei, Gang wrote:
> Oh, the question should be in what states all the AP CPU registers are. Do you 
> think we need to define the case like what Intel SDM defined for 
> getsec[SENTER]?
> 
> Jimmy

I'll take a look later today.

	-hpa


