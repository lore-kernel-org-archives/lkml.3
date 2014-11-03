Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750898AbaKCGom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 01:44:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41520 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbaKCGol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 01:44:41 -0500
Message-ID: <54572455.60102@suse.com>
Date: Mon, 03 Nov 2014 07:44:37 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
CC: hpa@zytor.com, x86@kernel.org, mingo@redhat.com,
        stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, david.vrabel@citrix.com,
        jbeulich@suse.com, toshi.kani@hp.com, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, bhelgaas@google.com
Subject: Re: [PATCH 00/17] x86: Full support of PAT
References: <1414764033-30011-1-git-send-email-jgross@suse.com> <20141031140600.GA31014@gmail.com> <alpine.DEB.2.11.1410311951230.5308@nanos>
In-Reply-To: <alpine.DEB.2.11.1410311951230.5308@nanos>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2014 07:53 PM, Thomas Gleixner wrote:
> On Fri, 31 Oct 2014, Ingo Molnar wrote:
>>
>> * Juergen Gross <jgross@suse.com> wrote:
>>
>>> Changes in V5:
>>> - split up first patch as requested by Ingo Molnar and Thomas Gleixner
>>> - add a helper function in pat_init_cache_modes() as requested by Ingo Molnar
>>
>> The structure of this series looks great to me now.
>
> And it actually was a pleasure to review.

You're welcome.

>
>> Just to make sure: the series is fully bisectable, it is supposed
>> to build and boot at every patch in the series, right?
>>
>> If nobody objects then I'll start applying this series in a
>> couple of days.
>
> I did not find anything except the question about losing the large pat
> bit. If that's resolved its good to go.
>
> Please add
>
>    Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
>
> to the whole series.

Thank you,

Juergen
