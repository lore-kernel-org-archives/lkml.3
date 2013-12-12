Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab3LLP4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 10:56:49 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:51778 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab3LLP4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 10:56:48 -0500
Date: Thu, 12 Dec 2013 10:56:35 -0500
From: Tejun Heo <tj@kernel.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: gregkh@linuxfoundation.org, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] sysfs, kernfs: remove duplicated include from
 file.c
Message-ID: <20131212155635.GG32683@htj.dyndns.org>
References: <CAPgLHd8YaiM_VQZ=6N_ujfJJKWeYVK6S96w5Kv3ikj1b3jyoLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd8YaiM_VQZ=6N_ujfJJKWeYVK6S96w5Kv3ikj1b3jyoLA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 07, 2013 at 02:07:36PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Remove duplicated include.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
