Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbaBXMfz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 07:35:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34215 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbaBXMfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 07:35:54 -0500
Message-ID: <530B3C91.5080206@zytor.com>
Date: Mon, 24 Feb 2014 04:35:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>, Daniel Borkmann <dborkman@redhat.com>
CC: davem@davemloft.net, mingo@elte.hu, tglx@linutronix.de, ffusco@redhat.com,
        tgraf@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86/hash: swap parameters of crc32_u32()
References: <53073986020000780011E2E1@nat28.tlf.novell.com> <5308938A.8070506@redhat.com> <530B0AF2020000780011E97B@nat28.tlf.novell.com>
In-Reply-To: <530B0AF2020000780011E97B@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 12:03 AM, Jan Beulich wrote:
> rte_hash_crc_4byte(uint32_t data, uint32_t init_val)
>
> as opposed to
>
> static inline u32 crc32_u32(u32 crc, u32 val)
>
> (quite obviously data <-> val and crc <-> init_val, supported
> by the second argument in each caller being named "seed").
>

"Quite obviously", but unfortunately wrong (see other email).

	-hpa


