Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbaBSKMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 05:12:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60360 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaBSKMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 05:12:32 -0500
Message-ID: <5304838B.4040500@canonical.com>
Date: Wed, 19 Feb 2014 11:12:27 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>, David Airlie <airlied@linux.ie>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Dave Airlie <airlied@redhat.com>,
        Emil Velikov <emil.l.velikov@gmail.com>
CC: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nouveau, ACPI: fix regression caused by b072e53
References: <1392785628-30633-1-git-send-email-jiang.liu@linux.intel.com>
In-Reply-To: <1392785628-30633-1-git-send-email-jiang.liu@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

op 19-02-14 05:53, Jiang Liu schreef:
> On some platforms, ACPI _DSM method (nouveau_op_dsm_muid, function 0)
> has special requirements on the fourth parameter, which is different
> from ACPI specifications. So revert to the private implementation
> to check availability of _DSM functions instead of using common
> acpi_check_dsm() interface.
>
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
> Hi Maarten,
> 	Thanks for bisecting. Could you please help to verify whether
> this patch fixes the regression?
>
Tested-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

I was wrong about the operator precedence, seems correct after all. :-)
