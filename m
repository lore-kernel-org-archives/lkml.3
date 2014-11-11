Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbaKKKgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 05:36:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35962 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179AbaKKKgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 05:36:11 -0500
Message-ID: <5461E698.9060904@suse.com>
Date: Tue, 11 Nov 2014 11:36:08 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [Xen-devel] [PATCH V3 1/8] xen: Make functions static
References: <1415684626-18590-1-git-send-email-jgross@suse.com> <1415684626-18590-2-git-send-email-jgross@suse.com> <5461E310.4070803@citrix.com>
In-Reply-To: <5461E310.4070803@citrix.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2014 11:21 AM, David Vrabel wrote:
> On 11/11/14 05:43, Juergen Gross wrote:
>> Some functions in arch/x86/xen/p2m.c are used locally only. Make them
>> static. Rearrange the functions in p2m.c to avoid forward declarations.
>>
>> While at it correct some style issues (long lines, use pr_warn()).
>
> Please don't add extra stuff like this.  In general if you feel yourself
> wring "while at it..." or "also..." then you need another patch.

I applied the changes only to functions I was moving, as checkpatch was
complaining. Documentation says this should be avoided only when moving
functions between files.

If you still think I should omit these changes I'll throw them out.

>
> I also don't care about long lines if they are under 100 characters.

I do. :-)

But same again: either no style corrections or all.


Juergen
