Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933938Ab3CHJPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 04:15:47 -0500
Received: from multi.imgtec.com ([194.200.65.239]:17848 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932815Ab3CHJPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 04:15:44 -0500
Message-ID: <5139AC39.90805@imgtec.com>
Date: Fri, 8 Mar 2013 09:15:37 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Al Viro <viro@zeniv.linux.org.uk>, Michal Marek <mmarek@suse.cz>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        <linux-kbuild@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mike Frysinger <vapier@gentoo.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        <linux-next@vger.kernel.org>
Subject: Re: [RFC -next] linux/linkage.h: fix symbol prefix handling
References: <1362656642-2693-1-git-send-email-james.hogan@imgtec.com> <87sj46wyf2.fsf@rustcorp.com.au>
In-Reply-To: <87sj46wyf2.fsf@rustcorp.com.au>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_03_08_09_15_38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On 08/03/13 00:03, Rusty Russell wrote:
> James Hogan <james.hogan@imgtec.com> writes:
>> Also the definition of SYMBOL_PREFIX in <linux/kernel.h> is removed as
>> it conflicts, isn't used anywhere, and is defined as a string so differs
>> from the assembly definition.
> 
> So now, if CONFIG_SYMBOL_PREFIX, SYMBOL_PREFIX is defined on the cmdline
> as a string.  Otherwise it's empty (not the empty string?):

No, SYMBOL_PREFIX is now defined as a non-string, same as asm files, but
the now unused definition in linux/kernel.h did define it as a string as
it used CONFIG_SYMBOL_PREFIX which is a string. When I said "and is
defined as a string" I was referring to the one in linux/kernel.h that
this removes.

Does that make sense? It's all a bit messy unfortunately (hence RFC).

Cheers
James

