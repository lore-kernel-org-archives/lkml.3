Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab3CVTzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 15:55:22 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:48546 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab3CVTzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 15:55:20 -0400
MIME-Version: 1.0
In-Reply-To: <514CB496.3080100@tilera.com>
References: <1363912851.1390.170.camel@x61.thuisdomein>
	<514CB496.3080100@tilera.com>
Date: Fri, 22 Mar 2013 23:55:20 +0400
Message-ID: <CAMo8BfJxJOZxW5vKESn69XY+0TuUVR2SwAR0G+JVU6EKcQz-fg@mail.gmail.com>
Subject: Re: [PATCH] arch: remove KCORE_ELF again
From: Max Filippov <jcmvbkbc@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Chris Metcalf <cmetcalf@tilera.com>, Chris Zankel <chris@zankel.net>,
        linux-xtensa@linux-xtensa.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 11:44 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> On 3/21/2013 8:40 PM, Paul Bolle wrote:
>> The Kconfig symbol KCORE_ELF was removed in v2.6.0, but reappeared in two
>> architectures. It is useless. Remove it again.
>>
>> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
>> ---
>> 0) Untested.
>>
>> 1) Sent as one patch. Feel free to tell me to split it up in two
>> patches.
>>
>>  arch/tile/Kconfig   |  5 -----
>>  arch/xtensa/Kconfig | 15 ---------------
>>  2 files changed, 20 deletions(-)
>
> I took the tile part of this patch into the tile tree.  Thanks!

Took the rest to the xtensa tree.

-- 
Thanks.
-- Max
