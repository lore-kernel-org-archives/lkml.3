Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab3A0B2j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 20:28:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56069 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942Ab3A0B2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 20:28:36 -0500
Message-ID: <51048250.6060108@zytor.com>
Date: Sat, 26 Jan 2013 17:26:40 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Dmitry Torokhov <dtor@vmware.com>,
        Ingo Molnar <mingo@kernel.org>, X86 ML <x86@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, JBeulich@suse.com,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH -v2 2/2] x86: Make Linux guest support optional
References: <20130125100655.GC23404@pd.tnic> <1359136777-4512-2-git-send-email-bp@alien8.de> <20130125180730.GA29810@dtor-ws.eng.vmware.com> <20130125182335.GA1380@pd.tnic> <20130125182925.GB29810@dtor-ws.eng.vmware.com> <20130125183507.GA4973@pd.tnic> <20130125184356.GB4973@pd.tnic>
In-Reply-To: <20130125184356.GB4973@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2013 10:43 AM, Borislav Petkov wrote:
> On Fri, Jan 25, 2013 at 07:35:07PM +0100, Borislav Petkov wrote:
>> Ok, if you prefer. We can definitely make all .o's which depend on
>> x86_hyper also depend on CONFIG_HYPERVISOR_GUEST - this solves the
>> whole deal trivially.
>>
>> I'll respin the patches.
>
> ... provided, of course, nothing out-of-tree is using x86_hyper. Can we
> assume that?
>

Out-of-tree code is responsible for keeping up, not the other way around.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

