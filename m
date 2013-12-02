Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab3LBKte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 05:49:34 -0500
Received: from 0106ds1-hvi.0.fullrate.dk ([90.184.84.98]:19610 "EHLO
	mail.knielsen-hq.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab3LBKtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 05:49:31 -0500
From: Kristian Nielsen <knielsen@knielsen-hq.org>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Dave Jones <davej@redhat.com>, Benjamin LaHaise <bcrl@kvack.org>,
        Kent Overstreet <kmo@daterainc.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: GPF in aio_migratepage
References: <20131126032645.GA32301@redhat.com>
	<20131126060132.GA6400@redhat.com> <20131126071953.GE9244@kmo-pixel>
	<20131126152337.GL15489@kvack.org>
	<87d2lh6h92.fsf@frigg.knielsen-hq.org>
	<529C5CA6.6090708@cn.fujitsu.com>
Date: Mon, 02 Dec 2013 11:49:24 +0100
In-Reply-To: <529C5CA6.6090708@cn.fujitsu.com> (Gu Zheng's message of "Mon, 02
	Dec 2013 18:10:46 +0800")
Message-ID: <877gbnplxn.fsf@frigg.knielsen-hq.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gu Zheng <guz.fnst@cn.fujitsu.com> writes:

> Hi Kristian, Dave,
>
> Could you please help to check whether the following patch can fix this issue?

> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  fs/aio.c |   28 ++++++++++------------------
>  1 files changed, 10 insertions(+), 18 deletions(-)
>

Ok. I've applied the patch to 3.13-rc2 and will give it a spin. I will let you
know if I encounter the failure again with the patch.

Thanks,

 - Kristian.
