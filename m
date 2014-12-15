Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751028AbaLOS3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 13:29:54 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:44204 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaLOS3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 13:29:51 -0500
MIME-Version: 1.0
In-Reply-To: <20141215145936.63d69713@lxorguk.ukuu.org.uk>
References: <1418623790-28429-1-git-send-email-cernekee@gmail.com>
	<1418623790-28429-4-git-send-email-cernekee@gmail.com>
	<20141215145936.63d69713@lxorguk.ukuu.org.uk>
Date: Mon, 15 Dec 2014 10:29:50 -0800
X-Google-Sender-Auth: 8E5p00Yoaii_M7iO-S3jcK5epUQ
Message-ID: <CA+55aFz28Q2rOR5bLRiKs_SanROAHF5F1SPyQCqcFNwg2_Xk-w@mail.gmail.com>
Subject: Re: [RFC 3/4] Documentation: Add cutoff periods for patch acceptance
From: Linus Torvalds <torvalds@linux-foundation.org>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Kevin Cernekee <cernekee@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Brian Norris <computersforpeace@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 6:59 AM, One Thousand Gnomes
<gnomes@lxorguk.ukuu.org.uk> wrote:
>> +
>> +  kernel.org "mainline:"  |  Patch may appear
>> +  field when posted       |  in released kernel
>> +  ------------------------+--------------------------------
>> +  3.18-rc[1-4]            |  3.19
>> +  3.18-rc[5-9]            |  3.20
>> +  3.18                    |  Merge window open - don't post
>> +  3.19-rc[1-4]            |  3.20
>> +  3.19-rc[5-9]            |  3.21
>> +  3.19                    |  Merge window open - don't post
>> +
>> +Bug fixes can typically be accepted at any time.
>
> That's exactly what was needed I think

So I don't think this is wrong per se, but I do think that it should
also have a clarification that

 (a) the above "may appear" is basically "best possible timings", and
things can get delayed by various issues

 (b) the exact timing is maintainer-specific.

For that (b) in particular, for fairly simple subsystems in
particular, some maintainers basically have their pull requests for
the merge window open *before* the merge window even starts, and for
them, the merge window itself isn't actually all that busy, it's often
the week before that is the busy one.  So the exact timing can vary by
maintainership, and while I think the above is a reasonable example,
it should perhaps be documented as such. An *example*, not a "this is
how it always works". If you are preparing a 50-patch monster, I
suspect you may want to talk to the maintainer you're planning on
spamming before you send it out.

                     Linus
