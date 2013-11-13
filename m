Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916Ab3KMOYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:24:31 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:59619 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755094Ab3KMOY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:24:29 -0500
Message-ID: <52838B95.6060007@hurleysoftware.com>
Date: Wed, 13 Nov 2013 09:24:21 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: John Tapsell <johnflux@gmail.com>
CC: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fbdev <linux-fbdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [GIT PULL] fbdev changes for 3.13
References: <52836BBB.4010502@ti.com>
In-Reply-To: <52836BBB.4010502@ti.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2013 07:08 AM, Tomi Valkeinen wrote:
> Hi Linus,
>
> The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f:
>
>    Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)
>
> are available in the git repository at:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux.git tags/fbdev-3.13
>
> for you to fetch changes up to 3a41c5dbe8bc396a7fb16ca8739e945bb003342e:
>
>    fb: reorder the lock sequence to fix potential dead lock (2013-11-11 15:52:59 +0200)
>
> ----------------------------------------------------------------
> fbdev changes for 3.13
>
> Nothing particularly stands out in this pull request. The biggest part of the
> changes are cleanups.
>
> Maybe one fix to mention is the "fb: reorder the lock sequence to fix potential
> dead lock" which hopefully fixes the fb locking issues reported by multiple
> persons.
>
...<snip>
>
> Gu Zheng (1):
>        fb: reorder the lock sequence to fix potential dead lock

John,

The above patch should fix the deadlock you found in fbcon_generic_blank().
Please re-test 3.13-rc1 when released [or Tomi's for-next branch now].

Regards,
Peter Hurley
