Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933210Ab3CLW1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:27:01 -0400
Received: from relay2.sgi.com ([192.48.179.30]:54121 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932065Ab3CLW1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:27:00 -0400
Message-ID: <513FABAD.508@sgi.com>
Date: Tue, 12 Mar 2013 15:26:53 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Dimitri Sivanich <sivanich@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        kgdb-bugreport@lists.sourceforge.net, x86@kernel.org,
        linux-kernel@vger.kernel.org, Tim Bird <tim.bird@am.sony.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Cong Wang <amwang@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH 05/14] KDB: add more exports for supporting KDB modules
References: <20130312193823.212544181@gulag1.americas.sgi.com> <20130312193824.025713118@gulag1.americas.sgi.com> <87obeo7530.fsf@xmission.com> <513FA625.2020300@sgi.com> <20130312221336.GA25699@kroah.com>
In-Reply-To: <20130312221336.GA25699@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 3/12/2013 3:13 PM, Greg Kroah-Hartman wrote:
> On Tue, Mar 12, 2013 at 03:03:17PM -0700, Mike Travis wrote:
>> Let me see if I can understand the concept better.  By denying
>> an external hardware vendor the use of KDB to support a significant
>> piece of proprietary hardware on Linux, I furthering the interests
>> of Linux and the community how?
>
> Did SGI lawyers really agree to this patch?  I consider you running this
> by them if you have any questions as to why we are objecting to this.
> If, after discussing it with them, they still are asking for this
> change, please resend it, with their signed-off-by: on it showing that
> they really want this change.
>
> greg k-h
>

There is nobody else involved believe me.  I am just trying to do
the right thing.  This is not that big an issue as it has absolutely
no relevance to anything within that patch set.  I'm trying to
improve the overall experience of using KDB, which I've found most
helpful in the past to get around some very thorny issues, particularly
in regards to bringing up new hardware.  If blocking that usage by
non-GPL modules is what's required, then by all means I'm for it.

But understanding more of why the restriction is in place, would be
very helpful the next time I encounter it.

Thanks,
Mike
