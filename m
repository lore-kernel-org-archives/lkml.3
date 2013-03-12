Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807Ab3CLWI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:08:56 -0400
Received: from relay2.sgi.com ([192.48.179.30]:40958 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755325Ab3CLWIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:08:55 -0400
Message-ID: <513FA773.9040402@sgi.com>
Date: Tue, 12 Mar 2013 15:08:51 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jason Wessel <jason.wessel@windriver.com>,
        Dimitri Sivanich <sivanich@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        kgdb-bugreport@lists.sourceforge.net, x86@kernel.org,
        linux-kernel@vger.kernel.org, Tim Bird <tim.bird@am.sony.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cong Wang <amwang@redhat.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH 05/14] KDB: add more exports for supporting KDB modules
References: <20130312193823.212544181@gulag1.americas.sgi.com> <20130312193824.025713118@gulag1.americas.sgi.com> <alpine.LFD.2.02.1303122245310.22263@ionos>
In-Reply-To: <alpine.LFD.2.02.1303122245310.22263@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 3/12/2013 3:01 PM, Thomas Gleixner wrote:
> On Tue, 12 Mar 2013, Mike Travis wrote:
>> This patch adds some important KDB functions to be externally
>> usable by loadable KDB modules.  Note that often drivers bring
>> in KDB modules for debugging, and in the past KDB has not been
>> limited to use by GPL only modules.  This patch restores KDB
>> usefullness to non-GPL modules.
>
> Which past? We only care about Linus git tree as THE past.
>
>> -EXPORT_SYMBOL_GPL(kdb_register);
>> +EXPORT_SYMBOL(kdb_register);
>
> AFAICT that function has never been an non GPL symbol in Linus
> tree. Whatever the original out of tree kdb stuff used is totally
> irrelevant.
>
> Stop trying to resolve your companys or your companys customers legal
> issues by false claims.
>
> The GPL is there for a reason.
>
> Aside of that the whole attempt to export stuff which has been not
> exported before without the _GPL extension is also:
>
> 	 Nacked-by: Thomas Gleixner <tglx@linutronix.de>
>
> Thanks,
>
> 	tglx
>

No problem, as I mentioned I don't care nor am I trying to resolve
anything except the problems of running Linux on the UV system.
There is no hidden agenda.

I will wait though for more feedback on the other patches before
submitting a 'v2' version.

Thanks,
Mike
