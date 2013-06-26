Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab3FZQiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:38:00 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:50150 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab3FZQh7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:37:59 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CADDKRnCP_s2hL2wr8TsKeToNRt5nXF3NBYAqkmCCUPX8HbY_yQ@mail.gmail.com>
References: <CADDKRnBf4i8ZQ4EXC15Sa6z9CZ55w0vBDnXG26sjWgdO9zH45w@mail.gmail.com>
	<CADDKRnCP_s2hL2wr8TsKeToNRt5nXF3NBYAqkmCCUPX8HbY_yQ@mail.gmail.com>
Date: Wed, 26 Jun 2013 18:37:57 +0200
Message-ID: <CA+icZUXJK2ks7TQbH0AiPYAWrFuQC85Uw2sSM6d_YD5yS7unhA@mail.gmail.com>
Subject: Re: [v3.10-rc2] iwlwifi regression
From: Sedat Dilek <sedat.dilek@gmail.com>
To: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 6:16 PM, Jörg Otte <jrg.otte@gmail.com> wrote:
> 2013/5/25 Jörg Otte <jrg.otte@gmail.com>:
>> If iwlwifi/iwldvm are built into the kernel (no loadable modules)
>> following error is written to console and syslog since v3.10-rc:
>>
>> iwlwifi 0000:08:00.0: failed to load module iwldvm (error -38), is
>> dynamic loading enabled?
>>
>> reverting
>> commit 1618b2b02a3a0ee7a6863fed4b0d22e697e7e97c
>> Author: Johannes Berg <johannes.berg@intel.com>
>> Date:   Thu Apr 4 10:35:23 2013 +0200
>>     iwlwifi: print warning on request_module failure
>>
>> fixes the problem for me.
>>
>> Jörg
>>
>> I'm not subscribed,please CC me in answeres
>
> We have rc-7 now and it's still not fixed. What is the problem?
>

The patch is pending in wireless.git and is not in mainline, right.
AFAICS there was a recent pull request... so should be in rc8.

commit 8edf3fd6eb0649b0f19363baf23bca39c6fbdba4
"iwlwifi: don't print module loading error if not modular"

- Sedat -

http://git.kernel.org/cgit/linux/kernel/git/linville/wireless.git/commit/?id=8edf3fd6eb0649b0f19363baf23bca39c6fbdba4

> Thanks, Jörg
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
