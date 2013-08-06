Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab3HFVIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:08:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43170 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754784Ab3HFVIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:08:17 -0400
Message-ID: <520165AD.704@zytor.com>
Date: Tue, 06 Aug 2013 14:07:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 03/16] x86, asmlinkage: Make all interrupt handlers asmlinkage
 / __visible
References: <1375740170-7446-1-git-send-email-andi@firstfloor.org> <1375740170-7446-4-git-send-email-andi@firstfloor.org>
In-Reply-To: <1375740170-7446-4-git-send-email-andi@firstfloor.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 03:02 PM, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> These handlers are all referenced from assembler stubs, so need
> to be visible.
> 
> The handlers without arguments become asmlinkage, the others __visible
> to not force regparms(0) on x86-32.
> 
> I put it all into a single patch, please let me know if you want
> it it split up.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

I'm getting massive conflicts on this patch, so I do need to understand
better what is your baseline, and yes, it probably would be useful to
split it up.

	-hpa


