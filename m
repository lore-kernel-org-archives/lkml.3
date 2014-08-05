Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbaHEHFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 03:05:35 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:62409 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006AbaHEHFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 03:05:33 -0400
MIME-Version: 1.0
X-Originating-IP: [89.139.10.210]
In-Reply-To: <53DFAB68.6020903@ti.com>
References: <1404836521-59637-1-git-send-email-s-anna@ti.com>
 <1404836521-59637-2-git-send-email-s-anna@ti.com> <CAK=Wgbawdik3ZB0Zbeaa7eXd7M+9ev9u713GcfOc4Gy0+O80Dg@mail.gmail.com>
 <53D7C769.6080500@ti.com> <CAK=Wgbbf5JNxzW16z=vXHi9D8Om1KnLEEr7hEw5T0oN7GuM=og@mail.gmail.com>
 <53DFAB68.6020903@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 5 Aug 2014 10:05:13 +0300
Message-ID: <CAK=WgbY5GGngd57=EBp+8_4djzMb5gZSOq0aQ9=vcpm-E9YQww@mail.gmail.com>
Subject: Re: [PATCH 1/2] remoteproc: use a flag to detect the presence of IOMMU
To: Suman Anna <s-anna@ti.com>
Cc: Dave Gerlach <d-gerlach@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Robert Tivy <rtivy@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 4, 2014 at 6:48 PM, Suman Anna <s-anna@ti.com> wrote:
> On 08/04/2014 06:50 AM, Ohad Ben-Cohen wrote:
>> On Tue, Jul 29, 2014 at 7:10 PM, Suman Anna <s-anna@ti.com> wrote:
>>> We are trying to add a remoteproc driver for a small Cortex M3 called
>>> the WkupM3 used for suspend/resume management on TI AM335/AM437x SoCs.
>>> This processor does not have an MMU. Same is the case with another
>>> processor subsystem PRU-ICSS on AM335/AM437x. All these are platform
>>> devices, and the current iommu_present check will not scale for the same
>>> kernel image to support OMAP4/OMAP5 and AM335/AM437x.
>>
>> That's perfect, thanks. Can you please add this use case description
>> to the commit log?
>
> I kept the current description generic, but sure, I can add this
> specific usecase examples to the commit log. I will post the revised
> patches once rc1 is out.

Thanks!
