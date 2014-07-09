Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbaGIDMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 23:12:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103AbaGIDMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 23:12:43 -0400
Message-ID: <53BCB2F1.3070400@redhat.com>
Date: Tue, 08 Jul 2014 23:11:45 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>, peterz@infradead.org,
        mingo@kernel.org, linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
CC: preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com
Subject: Re: [PATCH v3 06/12] sched: add per rq cpu_power_orig
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org> <1404144343-18720-7-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1404144343-18720-7-git-send-email-vincent.guittot@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 06/30/2014 12:05 PM, Vincent Guittot wrote:
> This new field cpu_power_orig reflects the available capacity of a
> CPUs unlike the cpu_power which reflects the current capacity that
> can be altered by frequency and rt tasks.
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>

Acked-by: Rik van Riel <riel@redhat.com>


- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTvLLxAAoJEM553pKExN6DKHsIALFlj278vKIifriFbVOOYgDf
RppA21YTjzYP8YE00h0INatqPeIBRn5u1ifHUzlAtGIIV8dWy5q8QKu3D5zxNPfH
hTxqyX/vMYcLTJOC9yXPS+mM/wcOx1JEpNnuRtF3UZgjG+70boPuGLvlecy+mxz9
mtW6StYOxX0/WgHgbWHMYaVDCKGdn5P2ey6azD2Hrvmp6XsVat8T9+ChdmRJ0/t+
0D7QrEo56h+YSU3l0TqoHFwT/8l8pyGGyYOi1ABeZIaY13W2SJu2Ec4cYhK6qqmN
uz69QWwTPa1gOPTqpj1f8g64/ckBjwKaA7hB9GLCqqk1cuI6PK22B5QJEg/9BpE=
=wa9A
-----END PGP SIGNATURE-----
