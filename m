Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbaBUGEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 01:04:15 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:55789 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaBUGEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 01:04:14 -0500
MIME-Version: 1.0
In-Reply-To: <53066544.8030404@intel.com>
References: <1392888200-27567-1-git-send-email-jiang.liu@linux.intel.com>
	<53066544.8030404@intel.com>
Date: Fri, 21 Feb 2014 16:04:12 +1000
Message-ID: <CAPM=9ty2hogvc1-kku+Y8H4M6a3cMGD7oLqN4FmLEMprPaCxuw@mail.gmail.com>
Subject: Re: [PATCH] nouveau, ACPI: fix regression caused by b072e53
From: Dave Airlie <airlied@gmail.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, David Airlie <airlied@linux.ie>,
        Dave Airlie <airlied@redhat.com>,
        Emil Velikov <emil.l.velikov@gmail.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 6:27 AM, Rafael J. Wysocki
<rafael.j.wysocki@intel.com> wrote:
> On 2/20/2014 10:23 AM, Jiang Liu wrote:
>>
>> Fix regression caused by commit b072e53, which breaks loading nouveau
>> driver on optimus laptops.
>>
>> On some platforms, ACPI _DSM method (nouveau_op_dsm_muid, function 0)
>> has special requirements on the fourth parameter, which is different
>> from ACPI specifications. So revert to the private implementation
>> to check availability of _DSM functions instead of using common
>> acpi_check_dsm() interface.
>>
>> Reported-and-Tested-by: Maarten Lankhorst
>> <maarten.lankhorst@canonical.com>
>> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>
>
> I'm taking this, because the commit that introduced the regression went in
> through my tree.
>
> In the future I'll appreciate CCing ACPI-related patches to linux-acpi,
> however.

Thanks,

Acked-by: Dave Airlie <airlied@redhat.com>

Dave.
