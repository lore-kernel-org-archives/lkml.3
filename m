Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937049Ab3DJQ3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 12:29:14 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:40962 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934835Ab3DJQ3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:29:13 -0400
MIME-Version: 1.0
In-Reply-To: <516592EE.8050006@amd.com>
References: <1365609459-3378-1-git-send-email-suravee.suthikulpanit@amd.com>
	<CAKocOOML1-=SJGyvYNGK9hyOZp3UPd2WANcWqm1Joo7V6sAQpQ@mail.gmail.com>
	<516592EE.8050006@amd.com>
Date: Wed, 10 Apr 2013 10:29:11 -0600
Message-ID: <CAKocOON3+17VNxyj-qZxX5QWo8ip039-17+JtPtPeBmRCZe9dw@mail.gmail.com>
Subject: Re: [PATCH 2/2 V5] iommu/amd: Add logic to decode AMD IOMMU event flag
From: Shuah Khan <shuahkhan@gmail.com>
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Cc: iommu@lists.linux-foundation.org, joro@8bytes.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 10:27 AM, Suravee Suthikulanit
<suravee.suthikulpanit@amd.com> wrote:
> On 4/10/2013 11:21 AM, Shuah Khan wrote:
>>
>> Good feature. Do you also plan to add decode logic for these flags.
>> For example, RZ is only meaningful when PR=1, RW is only meaningful
>> when
>> PR=1, TR=0, and I=0, and so on? This additional logic will be useful.
>>
>> Reviewed-by: Shuah Khan<shuahkhan@gmail.com>
>>
>> -- Shuah
>
> Additional filtering logic can also be added in the future.  This will also
> be important if we are planning on handling IOMMU errors.
>

Correct. Additional logic isn't necessary in this patch.

-- Shuah
