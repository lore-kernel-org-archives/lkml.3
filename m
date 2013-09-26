Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab3IZBfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 21:35:51 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:47970 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab3IZBfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 21:35:50 -0400
Message-ID: <52438F71.30909@hp.com>
Date: Thu, 26 Sep 2013 09:35:45 +0800
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Donald Dutile <ddutile@redhat.com>
Subject: Re: [PATCH 1/1] x86/iommu: correct ICS register offset
References: <1379053652-29206-1-git-send-email-zhen-hual@hp.com> <52381505.4010701@hp.com> <20130924110551.GC4532@8bytes.org>
In-Reply-To: <20130924110551.GC4532@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg,
     Thank you for reviewing this patch.

ZhenHua

On 09/24/2013 07:05 PM, Joerg Roedel wrote:
> On Tue, Sep 17, 2013 at 04:38:29PM +0800, ZhenHua wrote:
>> Hi Guys,
>>      Though  DMAR_ICS_REG is not used yet, I think this patch is
>> necessary. So please take a look at it.
> You are right, my Spec says the same. It doesn't matter much since the
> register seems to be unused in the VT-d driver. I applied the patch to
> iommu/fixes anyway.
>
>
> 	Joerg
>
>
> .
>

