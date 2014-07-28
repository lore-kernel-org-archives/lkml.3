Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389AbaG1Sxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 14:53:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbaG1Sxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 14:53:31 -0400
Message-ID: <53D69BE2.9010605@redhat.com>
Date: Mon, 28 Jul 2014 14:52:18 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>, peterz@infradead.org,
        mingo@kernel.org, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
CC: Morten.Rasmussen@arm.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        dietmar.eggemann@arm.com
Subject: Re: [PATCH v4 00/12] sched: consolidation of cpu_capacity
References: <1406569906-9763-1-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1406569906-9763-1-git-send-email-vincent.guittot@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/28/2014 01:51 PM, Vincent Guittot wrote:

> The usage_avg_contrib is based on the current implementation of
> the load avg tracking. I also have a version of the
> usage_avg_contrib that is based on the new implementation [3] but
> haven't provide the patches and results as [3] is still under
> review. I can provide change above [3] to change how 
> usage_avg_contrib is computed and adapt to new mecanism.
> 
> TODO: manage conflict with the next version of [4]

FWIW, your series makes sense to me, and only the first hunk of patch
8/12 looks like it would conflict with my patches, in that your patch
changes code that will only be reached in exceptional circumstances.

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJT1pviAAoJEM553pKExN6D4IoH/3Ou8H8kM5zhgDc4sDY5h+0F
qFDZIwdCWtKL36QfuZXIS/SXzikzs8XjxG7PIDj/sIEcpzs5jzGvlqAr/nTbQGlo
2ONnXobwSYSPbf8tEKrX4sdPS4YH1sd8+DgHC9TdYOgnWhdjpvfrwA9vFHmsZZvC
SxlLKCwqdWgtQPCJiGGJGdQOaB+OsNAJcoyo8OyokdOUrpMX30bfLT+8TiAiB/zS
uKrjzj3yZbrd/CRgpTSYopZgtzxHciZLLuIAurw7BJrUPL8Q1SL1HQ5eC5q/eS07
hXJrD6/o2DDfWoyeT2eDdJ9QkZKxT3vDKqC4WyVYn/2JZMzD5C+PY3XmQk7uYbU=
=zV+U
-----END PGP SIGNATURE-----
