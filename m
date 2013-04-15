Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab3DOCAW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:00:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52404 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754509Ab3DOCAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:00:21 -0400
Message-ID: <516B5F1F.1040106@zytor.com>
Date: Sun, 14 Apr 2013 18:59:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        WANG Chao <chaowang@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/4] x86, kdump: Set crashkernel_low automatically
References: <1365749691-21299-1-git-send-email-yinghai@kernel.org> <1365749691-21299-2-git-send-email-yinghai@kernel.org>
In-Reply-To: <1365749691-21299-2-git-send-email-yinghai@kernel.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2013 11:54 PM, Yinghai Lu wrote:

> +		/*
> +		 * two parts from lib/swiotlb.c:
> +		 *	swiotlb size: user specified with swiotlb= or default.
> +		 *	swiotlb overflow buffer: now is hardcoded to 32k,
> +		 *		round to 8M to cover more others.
> +		 */

This comment is incomprehensible.  "Cover more others"?


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

