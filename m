Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab3DXNwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 09:52:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044Ab3DXNwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 09:52:46 -0400
Message-ID: <5177E3A8.5020001@redhat.com>
Date: Wed, 24 Apr 2013 09:52:40 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121116 Thunderbird/10.0.11
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 V2] iommu/amd: Add workaround for ERBT1312
References: <1366009666-44792-1-git-send-email-suravee.suthikulpanit@amd.com> <20130418160220.GA4153@8bytes.org> <51701B9F.10003@amd.com> <20130418162856.GA13891@8bytes.org> <51768B25.1060501@redhat.com> <20130424104616.GH17148@8bytes.org>
In-Reply-To: <20130424104616.GH17148@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2013 06:46 AM, Joerg Roedel wrote:
> On Tue, Apr 23, 2013 at 09:22:45AM -0400, Don Dutile wrote:
>> Given other threads on this mail list (and I've seen crashes with same problem)
>> where this type of logging during a flood of IOMMU errors will lock up the machine,
>> is there something that can be done to break the do-while loop after n iterations
>> have been exec'd, so the kernel can progress during a crash ?
>
> In the case of an IOMMU error flood this loop will only run until the
> event-log/ppr-log overflows. So it should not turn into an endless loop.
>
>
> 	Joerg
>
>
Thanks for verification.

