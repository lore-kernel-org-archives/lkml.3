Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab3DMPGZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 11:06:25 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:48937 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab3DMPGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 11:06:24 -0400
MIME-Version: 1.0
In-Reply-To: <20130412080637.GN6858@8bytes.org>
References: <1365538384-12426-1-git-send-email-joro@8bytes.org>
	<CAKocOOP5tMsDLS8Wotu0kMNjSVJpN+pPhE9zj+n9ZKS9EcVR+A@mail.gmail.com>
	<20130412080637.GN6858@8bytes.org>
Date: Sat, 13 Apr 2013 23:06:22 +0800
Message-ID: <CAJtEV7aLa2tKw-B0f0ZNHdP86yxpvUAofs9eVPYCeib6m67f8g@mail.gmail.com>
Subject: Re: [PATCH 0/9] AMD IOMMU cleanups, fixes and IVRS bug workarounds
From: Andrew Cooks <acooks@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Shuah Khan <shuahkhan@gmail.com>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 4:06 PM, Joerg Roedel <joro@8bytes.org> wrote:
> Hi Shuah,
>
> On Wed, Apr 10, 2013 at 10:06:02AM -0600, Shuah Khan wrote:
>> On Tue, Apr 9, 2013 at 2:12 PM, Joerg Roedel <joro@8bytes.org> wrote:
>> >  Documentation/kernel-parameters.txt |   14 ++++
>> >  drivers/iommu/amd_iommu.c           |   79 +++++++-----------
>> >  drivers/iommu/amd_iommu_init.c      |  151 +++++++++++++++++++++++++++++++----
>> >  drivers/iommu/amd_iommu_types.h     |    1 +
>> >  4 files changed, 182 insertions(+), 63 deletions(-)
>
>> Reviewed all the patches in this set. No longer have access to test machine. :(
>
> Oh, that's sad. You were the only one having a machine wich actually has
> unity-mapped ranges defined in the BIOS table. The code for those
> mappings was basically untested before you ran it on that machine.
>
What is the machine in question? Maybe someone else has access to one,
if it's not too exotic.

--
a.
