Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab3J1NzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 09:55:18 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:35519 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004Ab3J1NzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 09:55:16 -0400
Message-ID: <526E6CC0.9090801@synopsys.com>
Date: Mon, 28 Oct 2013 19:25:12 +0530
From: Vineet Gupta <vineetg76@gmail.com>
Organization: Synopsys
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>,
        "jason.wessel@windriver.com" <jason.wessel@windriver.com>,
        "Mischa.Jonker@synopsys.com" <Mischa.Jonker@synopsys.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arc: kernel: kgdb: add default implementation for kgdb_roundup_cpus()
References: <526898F1.7010609@asianux.com>
In-Reply-To: <526898F1.7010609@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2013 09:21 AM, Chen Gang wrote:
> arc supports kgdb, but need update -- add function kgdb_roundup_cpus(),
> or can not pass compiling. At present, add the simple generic one just
> like other architectures(e.g. tile, mips ...).
>
> The related error (with allmodconfig):
>
>   kernel/built-in.o: In function `kgdb_cpu_enter':
>   kernel/debug/debug_core.c:580: undefined reference to `kgdb_roundup_cpus'
>
>
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

Applied for 3.13.

Thx,
-Vineet
