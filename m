Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbaJIAS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 20:18:29 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34219 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbaJIAST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 20:18:19 -0400
Message-ID: <5435D449.5030403@infradead.org>
Date: Wed, 08 Oct 2014 17:18:17 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Peter Foley <pefoley2@pefoley.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Chuck Ebbert <cebbert.lkml@gmail.com>,
        Josh Boyer <jwboyer@fedoraproject.org>, Jiri Kosina <jkosina@suse.cz>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: vdso_standalone_test_x86.c build failure on Linus' tree
References: <CA+5PVA5BeRMd28CUZPj+G2VbcwT0pG7gERk65xdMLXSp_59-RA@mail.gmail.com> <CALCETrUDkHH-FLwq9ZJ0wFeOkQVWUjTh-cJPL4Jq28sHCqhfFA@mail.gmail.com> <20141008154659.31f46436@as> <5435A4A4.1070101@zytor.com> <20141008160956.7584d303@as> <5435AABC.2010902@zytor.com> <CAOFdcFN4jBvATfBNbccpARf4DRXAhCy1wf8FNKLhudKnutPd6Q@mail.gmail.com> <CALCETrUCLw5si9S4LZT9dbO=UsftjJ63Q4vshfq3t=B2sywbZg@mail.gmail.com>
In-Reply-To: <CALCETrUCLw5si9S4LZT9dbO=UsftjJ63Q4vshfq3t=B2sywbZg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/14 16:18, Andy Lutomirski wrote:
> On Wed, Oct 8, 2014 at 4:11 PM, Peter Foley <pefoley2@pefoley.com> wrote:
>> On Wed, Oct 8, 2014 at 5:21 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> That we can't solve, but it is not okay to break the kernel build.
>>
>> Should I just make CONFIG_BUILD_DOCSRC depend on CROSS_COMPILE=""?
>> I'm not sure how much value would be added by implementing targetprogs
>> in kbuild, simply to increase build testing of Documentation/
> 
> Yes, IMO.  Let the kselftest people solve it, because they might have
> extra requirements.
> 
> --Andy

As I have said in the past, there are probably lots of source files in
Documentation/ that should be in tools/ or tools/testing/ instead.


-- 
~Randy
