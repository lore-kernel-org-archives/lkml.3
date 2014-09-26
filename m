Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069AbaIZAsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 20:48:36 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:56191 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbaIZAsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 20:48:35 -0400
Message-ID: <5424B7DF.4040006@converseincode.com>
Date: Thu, 25 Sep 2014 17:48:31 -0700
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: ak@linux.intel.com, yamada.m@jp.panasonic.com, hpa@linux.intel.com,
        linux-kernel@vger.kernel.org, sam@ravnborg.org,
        Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH] kbuild, LLVMLinux: Add -Werror to cc-option to support
 clang
References: <1411500522-11480-1-git-send-email-behanw@converseincode.com> <5422B3EF.4000800@suse.cz> <5423128D.8070708@converseincode.com> <542419CB.3090902@suse.cz>
In-Reply-To: <542419CB.3090902@suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/14 06:34, Michal Marek wrote:
> On 2014-09-24 20:50, Behan Webster wrote:
>> Getting clang to error on unused flags wasn't trivial (this change broke
>> a lot of builds apparently). Fortunately we weren't the only ones who
>> wanted it to behave like gcc in this case. I think it's going to be
>> *much* harder to do the same for warnings. The argument given by
>> supporters of the current situation is that if a warning isn't
>> supported, why break the build? *sigh*
> I guess the reason to accept unknown warnings opentions is compatibility
> with Makefiles with hardcoded gcc-isms. BTW, GCC at some point started
> to ignore unknown -Wno-* options, for everyone's good of course. That's
> why we ended up with the cc-disable-warning function. If -W* options for
> clang need special care, then it might be a good idea to introduce
> cc-warning with the conditional -Werror for clang. There are not that
> many places where we add warnings, so the patch would be still short.
> That way, the possible silent failure is limited only to warning options
> with clang, which is not such a big deal.
I'll try this approach.

Thanks,

Behan

-- 
Behan Webster
behanw@converseincode.com

