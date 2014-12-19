Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaLSBn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 20:43:26 -0500
Received: from unicorn.mansr.com ([81.2.72.234]:59564 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbaLSBnX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 20:43:23 -0500
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Joe Perches <joe@perches.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        Steven Miao <realmz6@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips <linux-mips@linux-mips.org>
Subject: Re: rfc: remove early_printk from a few arches? (blackfin, m68k, mips)
References: <1418849927.28384.1.camel@perches.com>
	<alpine.DEB.2.11.1412190031530.17382@nanos>
	<1418951658.28384.20.camel@perches.com>
Date: Fri, 19 Dec 2014 01:43:13 +0000
In-Reply-To: <1418951658.28384.20.camel@perches.com> (Joe Perches's message of
	"Thu, 18 Dec 2014 17:14:18 -0800")
Message-ID: <yw1x388ch0su.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> On Fri, 2014-12-19 at 00:33 +0100, Thomas Gleixner wrote:
>> On Wed, 17 Dec 2014, Joe Perches wrote:
>> > It seems like early_printk can be configured into
>> > a few architectures but also appear not to be used.
>> > 
>> > $ git grep -w "early_printk"
>> ...
>> > These seem to the only uses:
>> ... 
>> > So blackfin, m68k, and mips seems to have it possible to enable,
>> > but also don't appear at first glance to use it,
>> 
>> Hint: CONFIG_EARLY_PRINTK covers far more than early_printk()
>
> I know this.
>
> Note also I didn't specify CONFIG_EARLY_PRINTK,
> just early_printk.
>
>> > Is early_printk really used by these architectures?
>> > Should it be removed?
>> 
>> Sure, if you have a good reason to remove working functionality.
>
> Unused.

What exactly are you proposing to remove?  I see no unused code related
to early printk (in any variant) under arch/mips.

-- 
Måns Rullgård
mans@mansr.com
