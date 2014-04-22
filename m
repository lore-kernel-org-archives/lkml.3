Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbaDVKEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:04:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195AbaDVKEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:04:45 -0400
Message-ID: <535631EB.4060906@redhat.com>
Date: Tue, 22 Apr 2014 11:10:03 +0200
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
References: <1395256011-2423-1-git-send-email-dh.herrmann@gmail.com>	<5343F2EC.3050508@redhat.com> <CANq1E4TmtR=gSgR25PGC_EN=xrEEg1+F=zkTUGXZ4SHvjFNbag@mail.gmail.com>
In-Reply-To: <CANq1E4TmtR=gSgR25PGC_EN=xrEEg1+F=zkTUGXZ4SHvjFNbag@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2014 11:31 PM, David Herrmann wrote:

> On Tue, Apr 8, 2014 at 3:00 PM, Florian Weimer <fweimer@redhat.com> wrote:
>> How do you keep these promises on network and FUSE file systems?
>
> I don't. This is shmem only.

Ah.  What do you recommend for recipient to recognize such descriptors? 
  Would they just try to seal them and reject them if this fails?

-- 
Florian Weimer / Red Hat Product Security Team
