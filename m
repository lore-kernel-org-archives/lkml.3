Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab3JKTSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:18:49 -0400
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:40758 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab3JKTSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:18:48 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: dwmw2@infradead.org, artem.bityutskiy@linux.intel.com, jg1.han@samsung.com,
        dan.carpenter@oracle.com, yongjun_wei@trendmicro.com.cn,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtg: docg3: use free_bch() instead of kfree()
References: <CAPgLHd_vT4cJ1F1a6TDzYb2LFSb-me90K58K22Z=ae3VsOfbng@mail.gmail.com>
X-URL: http://belgarath.falguerolles.org/
Date: Fri, 11 Oct 2013 21:17:51 +0200
In-Reply-To: <CAPgLHd_vT4cJ1F1a6TDzYb2LFSb-me90K58K22Z=ae3VsOfbng@mail.gmail.com>
	(Wei Yongjun's message of "Fri, 11 Oct 2013 12:40:21 +0800")
Message-ID: <878uxzy5uo.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wei Yongjun <weiyj.lk@gmail.com> writes:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Use free_bch() instead of kfree() to free init_bch()
> allocated data.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>
