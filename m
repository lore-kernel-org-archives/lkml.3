Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471AbaDVMoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 08:44:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932152AbaDVMod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 08:44:33 -0400
Message-ID: <53566428.9080005@redhat.com>
Date: Tue, 22 Apr 2014 14:44:24 +0200
From: Florian Weimer <fweimer@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Kay Sievers <kay@vrfy.org>,
        Daniel Mack <zonque@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 0/6] File Sealing & memfd_create()
References: <1395256011-2423-1-git-send-email-dh.herrmann@gmail.com>	<5343F2EC.3050508@redhat.com>	<CANq1E4TmtR=gSgR25PGC_EN=xrEEg1+F=zkTUGXZ4SHvjFNbag@mail.gmail.com>	<535631EB.4060906@redhat.com> <CANq1E4TufnELwEDZAkzH94Zn3gb46qvxfDboN5y2mK=Q2gk9-Q@mail.gmail.com>
In-Reply-To: <CANq1E4TufnELwEDZAkzH94Zn3gb46qvxfDboN5y2mK=Q2gk9-Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2014 01:55 PM, David Herrmann wrote:
> Hi
>
> On Tue, Apr 22, 2014 at 11:10 AM, Florian Weimer <fweimer@redhat.com> wrote:
>> Ah.  What do you recommend for recipient to recognize such descriptors?
>> Would they just try to seal them and reject them if this fails?
>
> This highly depends on your use-case. Please see the initial email in
> this thread. It describes 2 example use-cases. In both cases, the
> recipients read the current set of seals and verify that a given set
> of seals is set.

I didn't find that very convincing.  But in v2, seals are monotonic, so 
checking them should be reliable enough.

What happens when you create a loop device on a write-sealed descriptor?

-- 
Florian Weimer / Red Hat Product Security Team
