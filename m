Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbbABPGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 10:06:18 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:52034 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbbABPGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 10:06:16 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <54A6B2C1.5090104@suse.cz>
References: <54A40743.8080401@suse.cz>
	<1420040119-32669-1-git-send-email-mmarek@suse.cz>
	<CA+icZUUpYCGTJ7mC1jCNUQi7fgw4qSAa+ga8JGPXhkYEK+Bmtw@mail.gmail.com>
	<54A6B2C1.5090104@suse.cz>
Date: Fri, 2 Jan 2015 16:06:15 +0100
Message-ID: <CA+icZUXtBRT1CpxL4VysrsjxFDuxrT3wNtHrECiWkoWK69pMkw@mail.gmail.com>
Subject: Re: [PATCH 1/2] kbuild: Fix removal of the debian/ directory
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Ben Hutchings <ben@decadent.org.uk>, max@stro.at,
        LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 2, 2015 at 4:01 PM, Michal Marek <mmarek@suse.cz> wrote:
> On 2014-12-31 16:50, Sedat Dilek wrote:
>> On Wed, Dec 31, 2014 at 4:35 PM, Michal Marek <mmarek@suse.cz> wrote:
>>> scripts/Makefile.clean treats absolute path specially, but
>>> $(objtree)/debian is no longer an absolute path since 7e1c0477 (kbuild:
>>> Use relative path for $(objtree). Work around this by checking if the
>>> path starts with $(objtree)/.
>>>
>>> Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
>>> Fixes: 7e1c0477 (kbuild: Use relative path for $(objtree)
>>> Signed-off-by: Michal Marek <mmarek@suse.cz>
>>
>> After applying your patchset, thing work as expected.
>>
>> Feel free to add my Tested-by.
>>
>> Hope this will get into v3.19-rc3?
>
> I pushed the patch to kbuild.git#rc-fixes. The 'clean-rule' removal is
> in kbuild.git#kbuild.
>

Thanks.
I had already pulled them into my local for-3.19/kbuild-fixes.

Can you take care of the long outstanding builddeb fix I posted a few
minutes ago ?
I you plan a git-pull request, can we have this in rc-fixes?
It's trivial - don't think we need any ACKs (which I got 2012/2013).

- Sedat -
