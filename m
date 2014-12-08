Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbaLHTRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 14:17:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbaLHTRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 14:17:05 -0500
Message-ID: <5485F923.3090301@redhat.com>
Date: Mon, 08 Dec 2014 20:16:51 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Christoph Jaeger <cj@linux.com>, yann.morin.1998@free.fr,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 2/3] kconfig: remove undocumented type definition alias
 'boolean'
References: <cover.1418003065.git.cj@linux.com>  <1539c3778a0f3533942f69540a9b5b3d1f965bdc.1418003065.git.cj@linux.com>  <1418064660.2058.11.camel@x220> <1418066039.2058.19.camel@x220>
In-Reply-To: <1418066039.2058.19.camel@x220>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2014 08:13 PM, Paul Bolle wrote:
> On Mon, 2014-12-08 at 19:51 +0100, Paul Bolle wrote:
>> This doesn't apply on next-20141208. What tree did you base this on?
>
> I got it to apply on next-20141208 by dropping the hunk for
> arch/cris/arch-v32/drivers/Kconfig and by making (trivial) context
> changes to the hunks for init/Kconfig and net/Kconfig.
>
> (My experience with actual maintainers is that they won't bother to do
> that. Anyhow, Kconfig is basically unmaintained. And I don't know which
> tree one should base ones Kconfig patches on.)

Well, I guess if in doubt then this could go into Andrew's tree. :)

> I'll muddle along...
>
>
> Paul Bolle
>
