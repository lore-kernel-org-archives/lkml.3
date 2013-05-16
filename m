Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab3EPXgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 19:36:17 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:36995 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab3EPXgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 19:36:15 -0400
Message-ID: <51956D6C.7090005@intel.com>
Date: Thu, 16 May 2013 16:36:12 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Power management and ACPI fixes for v3.10-rc2
References: <68458966.ga8OpWyZtA@vostro.rjw.lan> <CA+55aFxhDO0D1nQgTFWSiZT9AJMSF9oOUoxWj=Y=5en0nWC92g@mail.gmail.com>
In-Reply-To: <CA+55aFxhDO0D1nQgTFWSiZT9AJMSF9oOUoxWj=Y=5en0nWC92g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2013 03:25 PM, Linus Torvalds wrote:
> On Thu, May 16, 2013 at 1:07 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>
>> - intel_pstate driver fixes and cleanups from Dirk Brandewie and
>>    Wei Yongjun.
>
> Btw, is there some fundamental reason why the pstate driver is limited
> to so few models?
>
> I've tested it on models 0x25 (i5-670) and 0x3a (i5-3427U), and it
> seems to work. But neither model is listed. (only 0x2a and 0x2d are).
>
> I understand that people want to be careful, but it's not actually
> getting very much *testing* right now, is it? Are models 0x2a/0x2d
> actually special in any way?
>

No they are not I will send the patch out in the morning.

>                    Linus
>

