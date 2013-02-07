Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab3BGGzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 01:55:23 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:60117 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab3BGGzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 01:55:22 -0500
X-AuditID: 9c930179-b7c24ae00000119c-bf-51134fd8560f
From: Namhyung Kim <namhyung@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: mingo@kernel.org, peterz@infradead.org, jamie.iles@oracle.com,
        penberg@kernel.org, acme@ghostprotocols.net, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/11] liblockdep: preload helper
References: <1360188694-25077-1-git-send-email-sasha.levin@oracle.com>
	<1360188694-25077-12-git-send-email-sasha.levin@oracle.com>
Date: Thu, 07 Feb 2013 15:55:20 +0900
In-Reply-To: <1360188694-25077-12-git-send-email-sasha.levin@oracle.com>
	(Sasha Levin's message of "Wed, 6 Feb 2013 17:11:34 -0500")
Message-ID: <8738x8sjdz.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  6 Feb 2013 17:11:34 -0500, Sasha Levin wrote:
> diff --git a/tools/lib/lockdep/lockdep b/tools/lib/lockdep/lockdep
> new file mode 100755
> index 0000000..616bf9a
> --- /dev/null
> +++ b/tools/lib/lockdep/lockdep
> @@ -0,0 +1,3 @@
> +#! /bin/bash
> +
> +LD_PRELOAD=liblockdep.so "$@"

Just try to be more conservative ;-)

  LD_PRELOAD="liblockdep.so $LD_PRELOAD" "$@"

Thanks,
Namhyung
