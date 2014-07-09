Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbaGIDL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 23:11:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbaGIDL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 23:11:58 -0400
Message-ID: <53BCB2AC.2090704@redhat.com>
Date: Tue, 08 Jul 2014 23:10:36 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>, peterz@infradead.org,
        mingo@kernel.org, linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
CC: preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com
Subject: Re: [PATCH v3 03/12] sched: fix avg_load computation
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org> <1404144343-18720-4-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1404144343-18720-4-git-send-email-vincent.guittot@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 06/30/2014 12:05 PM, Vincent Guittot wrote:
> The computation of avg_load and avg_load_per_task should only takes
> into account the number of cfs tasks. The non cfs task are already
> taken into account by decreasing the cpu's capacity (cpu_power) and
> they will be tracked in the CPU's utilization (group_utilization)
> of the next patches
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>

Acked-by: Rik van Riel <riel@redhat.com>

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTvLKrAAoJEM553pKExN6Dcz4H/2lJUVmEEzBOxc23cbYSXJcR
E1shwcwfbGe/0GwHwWOB4+9UyDuxp6pO6PaQ581nZZZ3sWSifjrViJqtoBheoERY
yIH3zbnpPVBD3JNOVA/5XjHSdnYye/Qf23TVsaC/Jd2O8MH3oilJFJTbOoeU+ns7
DREwq0T4T7RnLo9oVc6eLyWf9Ouc3FufAH41u48y702Ppbw1qnOU/ZSRhTLWpgoR
PjybIcEaNBugMHxv4CCjcU74VkYGoMupN93QZeuG71MwOjbkUQIIRwp4De9MW0Rw
59eO97StrE6o3oLcNaoqHPM3OzyvejF03soW6jROQJsTq3Ck7nD9jjGwav+TwO4=
=TC6D
-----END PGP SIGNATURE-----
