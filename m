Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498Ab3GBIrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 04:47:42 -0400
Received: from canardo.mork.no ([148.122.252.1]:32769 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932225Ab3GBIrk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 04:47:40 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Wrapping EXPORT_SYMBOL_GPL symbols and re-exporting the wrappers with EXPORT_SYMBOL
Organization: m
References: <87bo6m2yok.fsf@nemi.mork.no> <20130701213859.GC23539@pd.tnic>
	<CAFLxGvw5byx2gu47oD5yOMSHHxieh8qs0z5ZyeCRpAi7T3ibOA@mail.gmail.com>
Date: Tue, 02 Jul 2013 10:47:19 +0200
In-Reply-To: <CAFLxGvw5byx2gu47oD5yOMSHHxieh8qs0z5ZyeCRpAi7T3ibOA@mail.gmail.com>
	(richard's message of "Tue, 2 Jul 2013 09:57:08 +0200")
Message-ID: <87hagdz6ug.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

richard -rw- weinberger <richard.weinberger@gmail.com> writes:
> On Mon, Jul 1, 2013 at 11:38 PM, Borislav Petkov <bp@alien8.de> wrote:
>> On Mon, Jul 01, 2013 at 03:32:27PM +0200, Bjørn Mork wrote:
>>> I just got a new wireless router and stumbled across an odd set of
>>> out-of-tree modules, where two GPL licensed modules were used by a third
>>> proprietary licensed one.
>>>
>>> The nice router vendor sent me the GPL'd source code, and as expected
>>> the GPL modules are little more than wrappers working around the
>>> EXPORT_SYMBOL_GPL restrictions.  Here's a complete example of one of
>>> them:
>>
>> I'm wondering if we could fail building modules which do EXPORT_SYMBOL.
>
> Then vendors will do a s/EXPORT_SYMBOL_GPL/EXPORT_SYMBOL/g on the kernel.
> Recently I've identified such a case.

Well, in this particular case I don't think that would happen.  I
believe the router vendor is actually trying their best to comply with
the GPL.  They have a well documented and working way to request full
source, and the source I received seems complete and matching the latest
firmware version (as requested).

I believe they are unware of this issue in a minor software component
they have obviously bought from a 3rd party, sold as a SDK with a few
standalone kernel modules . I do believe the router vendor would have
refused if this software required any modifications to the kernel.  I
believe the same goes for the SoC vendor which of course is responsible
for most of the firmware, including the kernel.

> Bjørn, please post this on legal@lists.gpl-violations.org too.

Done.



Bjørn
