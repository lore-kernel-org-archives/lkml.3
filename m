Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761Ab3ANUmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 15:42:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58107 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756779Ab3ANUmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 15:42:53 -0500
Message-ID: <50F46DAC.6040501@zytor.com>
Date: Mon, 14 Jan 2013 12:42:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7u1 25/31] memblock: add memblock_mem_size()
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org> <1357260531-11115-26-git-send-email-yinghai@kernel.org>
In-Reply-To: <1357260531-11115-26-git-send-email-yinghai@kernel.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2013 04:48 PM, Yinghai Lu wrote:
>  
> -	mapped_size = get_mem_size(max_pfn_mapped);
> +	mapped_size = (u64)memblock_mem_size(max_pfn_mapped);

This cast is completely unnecessary.

	-hpa


