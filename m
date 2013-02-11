Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759467Ab3BKTm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 14:42:27 -0500
Received: from relay1.sgi.com ([192.48.179.29]:50046 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758451Ab3BKTmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 14:42:25 -0500
Message-ID: <5119499F.8070200@sgi.com>
Date: Mon, 11 Feb 2013 11:42:23 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] x86/UV/UV3: Kernel Updates for SGI UV3.
References: <20130211193252.865583940@gulag1.americas.sgi.com>
In-Reply-To: <20130211193252.865583940@gulag1.americas.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[sorry about that, it sent the mailbox instead of each patch.  I talked
to Dimitri and he doesn't care about being the originator of the patch
so I'm just going to resend with me as the From: person.]

On 2/11/2013 11:32 AM, Mike Travis wrote:
> Kernel updates for SGI Ultraviolet System 3 (UV3).
>
> The new MMR definitions are added, and then the updates to each module
> are applied.  Afterwards, a "trim" patch reduces the size of the MMR
> definitions file by about a third.  This keeps "bi-sectability" in place.
>
>
>>Fromtravis@gulag1.americas.sgi.com  Mon Feb 11 13:32:53 2013
> Message-Id:<20130211193252.982866660@gulag1.americas.sgi.com>
> User-Agent: quilt/0.47-15.17.1
> Date: Mon, 11 Feb 2013 13:32:53 -0600
> From: Mike Travis<travis@sgi.com>
> To: Thomas Gleixner<tglx@linutronix.de>,
>   Ingo Molnar<mingo@kernel.org>,
>   "H. Peter Anvin"<hpa@zytor.com>
> Cc: Andrew Morton<akpm@linux-foundation.org>,
>   x86@kernel.org,
>   linux-kernel@vger.kernel.org,
>   Russ Anderson<rja@sgi.com>
> Bcc:travis@sgi.com
> Subject: [PATCH 1/7] x86/UV/UV3: Update MMR register definitions for SGI Ultraviolet System 3 (UV3)
> References:<20130211193252.865583940@gulag1.americas.sgi.com>
> Content-Disposition: inline; filename=uv3-update-mmrs.patch
