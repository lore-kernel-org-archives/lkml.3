Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbaJ1NTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 09:19:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbaJ1NTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:19:38 -0400
Message-ID: <544F97C4.8000203@redhat.com>
Date: Tue, 28 Oct 2014 09:19:00 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Fabian Frederick <fabf@skynet.be>, isimatu.yasuaki@jp.fujitsu.com,
        linux-doc@vger.kernel.org, kexec@lists.infradead.org,
        linux-api@vger.kernel.org, jason.wessel@windriver.com
Subject: Re: [PATCH V4] kernel, add bug_on_warn
References: <1414155207-29839-1-git-send-email-prarit@redhat.com> <20141028121636.GC3274@tassilo.jf.intel.com> <544F8A78.9070008@redhat.com> <20141028122900.GA10632@redhat.com> <20141028124425.GD3274@tassilo.jf.intel.com> <544F90B1.1070102@redhat.com> <20141028125630.GF3274@tassilo.jf.intel.com>
In-Reply-To: <20141028125630.GF3274@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/28/2014 08:56 AM, Andi Kleen wrote:
>>> If you have a command line option to execute kdb commands you still
>>> would only have a command line option, just a slightly longer one.
>>>
>>> kdb="on, bp warn_slowpath_common sr c, go" 
>>
>> KDB is not on all kernels.  This would require me to go to great lengths to
> 
> Repeating incorrect statements doesn't suddenly make them correct.

It does when you're introducing unnecessary complexity here Andi.  You're not
listening to the original statement: I do not want to provide a modified kernel
to an end user for this simple situation anymore.

> 
> Assuming KDB is compiled in the only setup needed would be the line above.

That's a HUGE assumption.  It isn't and I'm still stuck in the same mess of
explaining how to recompile a kernel and/or providing a modified kernel to an
end user.  That isn't a good solution.

P.

> 
> -Andi
> 
