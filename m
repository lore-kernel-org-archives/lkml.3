Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbaGaPfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 11:35:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43910 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbaGaPft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 11:35:49 -0400
Message-ID: <53DA624B.9000403@canonical.com>
Date: Thu, 31 Jul 2014 17:35:39 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: airlied@linux.ie
CC: thellstrom@vmware.com, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com, alexander.deucher@amd.com,
        christian.koenig@amd.com
Subject: Re: [PATCH 00/17] Convert TTM to the new fence interface. v2
References: <20140731152809.14619.29424.stgit@patser>
In-Reply-To: <20140731152809.14619.29424.stgit@patser>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

op 31-07-14 17:30, Maarten Lankhorst schreef:
> This series applies on top of the driver-core-next branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
>
> Before converting ttm to the new fence interface I had to fix some
> drivers to require a reservation before poking with fence_obj.
> After flipping the switch RCU becomes available instead, and
> the extra reservations can be dropped again. 
>
> I've done at least basic testing on all the drivers I've converted
> at some point, but more testing is definitely welcomed!
>
> Changes since v1:
> - Almost all radeon changes, radeon reworked their page flip code which
>   made things easier for me.
> - Added a delayed work for radeon that checks gpu lockups.
> - Reworked the radeon fence implementation to remove deadlocks,
>   and end up slightly cleaner.
>
Oops, managed to screw up sending patches. There are 19 patches in this series, starting with

[PATCH 01/19] fence: add debugging lines to fence_is_signaled for the callback

Sorry for the noise.

~Maarten
