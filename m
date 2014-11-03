Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750969AbaKCGgL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 01:36:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41482 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbaKCGgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 01:36:08 -0500
Message-ID: <54572256.5050707@suse.com>
Date: Mon, 03 Nov 2014 07:36:06 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: hpa@zytor.com, x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, ville.syrjala@linux.intel.com,
        david.vrabel@citrix.com, jbeulich@suse.com, toshi.kani@hp.com,
        plagnioj@jcrosoft.com, tomi.valkeinen@ti.com, bhelgaas@google.com
Subject: Re: [PATCH 01/17] x86: Make page cache mode a real type
References: <1414764033-30011-1-git-send-email-jgross@suse.com> <1414764033-30011-2-git-send-email-jgross@suse.com> <20141031194207.GA15367@pd.tnic> <20141031202322.GB15935@laptop.dumpdata.com> <20141031203554.GA15363@pd.tnic>
In-Reply-To: <20141031203554.GA15363@pd.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2014 09:35 PM, Borislav Petkov wrote:
> On Fri, Oct 31, 2014 at 04:23:22PM -0400, Konrad Rzeszutek Wilk wrote:
>>>> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
>>>> Signed-off-by: Juergen Gross <jgross@suse.com>
>>>
>>> Just a clarification question: how is one to understand this attribution
>>> here? Is Stefan the original author, was he a reviewer, or? Because this
>>> SOB chain is misleading...
>>
>> He was the first then Juergen took over. Should the SOB order be inversed?
>
> Well, I'd say:
>
> Originally-by: Stefan...
>
> or
>
> Based-on-patch-by: Stefan...

I think this would fit best.

Shall I respin another version modifying the SOB to above?


Juergen

