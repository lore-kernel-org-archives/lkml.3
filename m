Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab3HGIuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 04:50:04 -0400
Received: from intranet.asianux.com ([58.214.24.6]:11967 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786Ab3HGIuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 04:50:01 -0400
X-Spam-Score: -100.8
Message-ID: <520209FA.70409@asianux.com>
Date: Wed, 07 Aug 2013 16:48:58 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Joe Perches <joe@perches.com>, "'Jiri Kosina'" <trivial@kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, davej@redhat.com,
        Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH trivial] UAPI: Kbuild: add/modify comments for "uapi/Kbuild"
 and "uapi/linux/Kbuild"
References: <52005571.4080704@asianux.com> <1375810303.2424.28.camel@joe-AO722> <1375860749.8422.25@driftwood>
In-Reply-To: <1375860749.8422.25@driftwood>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 03:32 PM, Rob Landley wrote:
> On 08/06/2013 12:31:43 PM, Joe Perches wrote:
>> On Tue, 2013-08-06 at 09:46 +0800, Chen Gang wrote:
>> > "include/uapi/" is the whole Linux kernel API, it is important enough
>> > to get more global explanations by comments.
>>
>> It'd probably be useful to have more descriptions
>> of uapi in the Documentation directory too.
> 
> I'd rather have comments in the headers that get exported to userspace
> and then have other forms of documentation generated from that by some
> process similar to "make htmldocs". Otherwise you've got two places to
> keep in sync.
> 

At least for me, it is a good idea, although UAPI files is rarely
changed (may add new item, but few modifying the existing items).

And for our case, it is summary comments for directory organization for
all UAPI files, so in my opinion, it is still necessary to give summary
comments in Kbuild.

In Linux user mode or another OS which share the same files of UAPI,
they do not care about our kernel's Kbuild, for they have their own
directory organizations which may different with Linux kernel's.

> (Really the guy you've got to keep in the loop about this is Michael
> Kerrisk. The section 2 man pages are the current best reference on UAPI
> stuff...)
> 

As far as I know, the section 2 man pages is already for it (e.g. man 2
setfuid, man 2 open, ...).

Do you mean currently it is only for some of system calls (part of
UAPI), not for the whole UAPI ?


> Rob
> 


-- 
Chen Gang
