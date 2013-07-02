Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab3GBIDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 04:03:39 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:55967 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab3GBIDe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 04:03:34 -0400
MIME-Version: 1.0
In-Reply-To: <20130701213859.GC23539@pd.tnic>
References: <87bo6m2yok.fsf@nemi.mork.no>
	<20130701213859.GC23539@pd.tnic>
Date: Tue, 2 Jul 2013 09:57:08 +0200
Message-ID: <CAFLxGvw5byx2gu47oD5yOMSHHxieh8qs0z5ZyeCRpAi7T3ibOA@mail.gmail.com>
Subject: Re: Wrapping EXPORT_SYMBOL_GPL symbols and re-exporting the wrappers
 with EXPORT_SYMBOL
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>,
        LKML <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 1, 2013 at 11:38 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Jul 01, 2013 at 03:32:27PM +0200, Bjørn Mork wrote:
>> I just got a new wireless router and stumbled across an odd set of
>> out-of-tree modules, where two GPL licensed modules were used by a third
>> proprietary licensed one.
>>
>> The nice router vendor sent me the GPL'd source code, and as expected
>> the GPL modules are little more than wrappers working around the
>> EXPORT_SYMBOL_GPL restrictions.  Here's a complete example of one of
>> them:
>
> I'm wondering if we could fail building modules which do EXPORT_SYMBOL.

Then vendors will do a s/EXPORT_SYMBOL_GPL/EXPORT_SYMBOL/g on the kernel.
Recently I've identified such a case.

Bjørn, please post this on legal@lists.gpl-violations.org too.

--
Thanks,
//richard
