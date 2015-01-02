Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbbABPBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 10:01:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47739 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbbABPBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 10:01:23 -0500
Message-ID: <54A6B2C1.5090104@suse.cz>
Date: Fri, 02 Jan 2015 16:01:21 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: Ben Hutchings <ben@decadent.org.uk>, max@stro.at,
        LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/2] kbuild: Fix removal of the debian/ directory
References: <54A40743.8080401@suse.cz>	<1420040119-32669-1-git-send-email-mmarek@suse.cz> <CA+icZUUpYCGTJ7mC1jCNUQi7fgw4qSAa+ga8JGPXhkYEK+Bmtw@mail.gmail.com>
In-Reply-To: <CA+icZUUpYCGTJ7mC1jCNUQi7fgw4qSAa+ga8JGPXhkYEK+Bmtw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-12-31 16:50, Sedat Dilek wrote:
> On Wed, Dec 31, 2014 at 4:35 PM, Michal Marek <mmarek@suse.cz> wrote:
>> scripts/Makefile.clean treats absolute path specially, but
>> $(objtree)/debian is no longer an absolute path since 7e1c0477 (kbuild:
>> Use relative path for $(objtree). Work around this by checking if the
>> path starts with $(objtree)/.
>>
>> Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
>> Fixes: 7e1c0477 (kbuild: Use relative path for $(objtree)
>> Signed-off-by: Michal Marek <mmarek@suse.cz>
> 
> After applying your patchset, thing work as expected.
> 
> Feel free to add my Tested-by.
> 
> Hope this will get into v3.19-rc3?

I pushed the patch to kbuild.git#rc-fixes. The 'clean-rule' removal is
in kbuild.git#kbuild.

Michal

