Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbaJHXSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 19:18:53 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:55092 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaJHXSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 19:18:52 -0400
MIME-Version: 1.0
In-Reply-To: <CAOFdcFN4jBvATfBNbccpARf4DRXAhCy1wf8FNKLhudKnutPd6Q@mail.gmail.com>
References: <CA+5PVA5BeRMd28CUZPj+G2VbcwT0pG7gERk65xdMLXSp_59-RA@mail.gmail.com>
 <CALCETrUDkHH-FLwq9ZJ0wFeOkQVWUjTh-cJPL4Jq28sHCqhfFA@mail.gmail.com>
 <20141008154659.31f46436@as> <5435A4A4.1070101@zytor.com> <20141008160956.7584d303@as>
 <5435AABC.2010902@zytor.com> <CAOFdcFN4jBvATfBNbccpARf4DRXAhCy1wf8FNKLhudKnutPd6Q@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 8 Oct 2014 16:18:30 -0700
Message-ID: <CALCETrUCLw5si9S4LZT9dbO=UsftjJ63Q4vshfq3t=B2sywbZg@mail.gmail.com>
Subject: Re: vdso_standalone_test_x86.c build failure on Linus' tree
To: Peter Foley <pefoley2@pefoley.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Chuck Ebbert <cebbert.lkml@gmail.com>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Randy Dunlap <rdunlap@infradead.org>, Jiri Kosina <jkosina@suse.cz>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 8, 2014 at 4:11 PM, Peter Foley <pefoley2@pefoley.com> wrote:
> On Wed, Oct 8, 2014 at 5:21 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> That we can't solve, but it is not okay to break the kernel build.
>
> Should I just make CONFIG_BUILD_DOCSRC depend on CROSS_COMPILE=""?
> I'm not sure how much value would be added by implementing targetprogs
> in kbuild, simply to increase build testing of Documentation/

Yes, IMO.  Let the kselftest people solve it, because they might have
extra requirements.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
