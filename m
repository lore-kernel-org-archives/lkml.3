Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbaKKKzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 05:55:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36322 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbaKKKzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 05:55:54 -0500
Message-ID: <5461EB37.4010603@suse.com>
Date: Tue, 11 Nov 2014 11:55:51 +0100
From: =?windows-1252?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [Xen-devel] [PATCH V3 1/8] xen: Make functions static
References: <1415684626-18590-1-git-send-email-jgross@suse.com> <1415684626-18590-2-git-send-email-jgross@suse.com> <5461E310.4070803@citrix.com> <5461E698.9060904@suse.com> <5461EA02.3020400@citrix.com>
In-Reply-To: <5461EA02.3020400@citrix.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2014 11:50 AM, David Vrabel wrote:
> On 11/11/14 10:36, Juergen Gross wrote:
>> On 11/11/2014 11:21 AM, David Vrabel wrote:
>>> On 11/11/14 05:43, Juergen Gross wrote:
>>>> Some functions in arch/x86/xen/p2m.c are used locally only. Make them
>>>> static. Rearrange the functions in p2m.c to avoid forward declarations.
>>>>
>>>> While at it correct some style issues (long lines, use pr_warn()).
>>>
>>> Please don't add extra stuff like this.  In general if you feel yourself
>>> wring "while at it..." or "also..." then you need another patch.
>>
>> I applied the changes only to functions I was moving, as checkpatch was
>> complaining. Documentation says this should be avoided only when moving
>> functions between files.
>
> If the documentation says that then it is wrong.  Fix the style issues
> in one patch and then move the functions in another.

Okay.

Juergen

