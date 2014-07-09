Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbaGIDML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 23:12:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754380AbaGIDMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 23:12:08 -0400
Message-ID: <53BCB2CB.6050108@redhat.com>
Date: Tue, 08 Jul 2014 23:11:07 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>, peterz@infradead.org,
        mingo@kernel.org, linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
CC: preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com
Subject: Re: [PATCH v3 04/12] sched: Allow all archs to set the power_orig
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org> <1404144343-18720-5-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1404144343-18720-5-git-send-email-vincent.guittot@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 06/30/2014 12:05 PM, Vincent Guittot wrote:
> power_orig is only changed for system with a SMT sched_domain level
> in order to reflect the lower capacity of CPUs. Heterogenous system
> also have to reflect an original capacity that is different from
> the default value.
> 
> Create a more generic function arch_scale_cpu_power that can be
> also used by non SMT platform to set power_orig.
> 
> The weak behavior of arch_scale_cpu_power is the previous SMT one
> in order to keep backward compatibility in the use of power_orig.
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>

Acked-by: Rik van Riel <riel@redhat.com>


- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTvLLLAAoJEM553pKExN6D/bAH/3bwSpTQUfp37uMHo42JEwHV
+GiMv+Q8dnVi6/b14UEYaRa0T7ELBOfbAvn7MjUDJVTGDOhCptXuE1Xedz+fKh01
FaVA5sJmCtyhH6v1n8q0PM5D/HcL6WRCBuf91Mx+3aSJhHcULRgN22wajYfxFOEy
IBPQjwwxjbWOBsN4l8UevMnzOVLV3S9I/+NHHTRmIcPpc/gdREO31ey4LX4E1y4U
sni6exOmhjYGiWgYwt9x5+Fmio0EwqVbSsdygWrSJykjW5dcUfM5A6ACp44u7keK
L2tb/eiZthGGd+ct4J08nF51BLrXUAIBcyXM3wxWNFCIQkwhbnVxYapkfmSfe48=
=ucGA
-----END PGP SIGNATURE-----
