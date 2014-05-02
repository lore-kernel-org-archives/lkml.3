Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbaEBPhd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:37:33 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:61504 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaEBPha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:37:30 -0400
MIME-Version: 1.0
In-Reply-To: <20140502153617.GH10204@htj.dyndns.org>
References: <1398346023-10225-1-git-send-email-yxlraid@gmail.com>
	<20140502153617.GH10204@htj.dyndns.org>
Date: Fri, 2 May 2014 08:37:29 -0700
Message-ID: <CAPcyv4h6+Wuh+NuOAfrN3bCSe877xEz_8nReZrX+K5jN9Oroeg@mail.gmail.com>
Subject: Re: [PATCH 0/3] libsas: add support for port multiplier
From: Dan Williams <dan.j.williams@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Xiangliang Yu <yxlraid@gmail.com>,
        James Bottomley <JBottomley@parallels.com>,
        Todd E Brandt <todd.e.brandt@intel.com>,
        Lukasz Dorau <lukasz.dorau@intel.com>,
        "IDE/ATA development list" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2014 at 8:36 AM, Tejun Heo <tj@kernel.org> wrote:
> On Thu, Apr 24, 2014 at 09:27:03PM +0800, Xiangliang Yu wrote:
>> This patch set will support SATA port multiplier(PM) in LIBSAS.
>>
>> LIBSAS is need to implement several key handling to support SATA PM:
>> First,low level driver notify libsas that SATA PM is attached to HBA port.
>> Then, LIBSAS will need to schedule SATA PMP error handler to scan SATA device
>> that is attached to PM, so we must implemet port softreset and PMP reset
>> handling.
>> If find SATA devices, we should add the devices into SAS transport layer.
>> In order to find SAS domain device we must implemet device type transformation
>> : scsi device -> (port number) -> ata device -> domain device. Then, we can
>> execute IO operation.
>>
>> In these patches, patch 1 is change SATA error handler.
>> And patch 2 will add SATA device into SAS layer and implement device type
>> transformation. Patch 3 implement SATA functional interface in mvsas.
>
> Please properly thread the patchset from the next posting.
>
> Dan, can you please take a look at this?
>

Yeah, it's on my plate to look at...
