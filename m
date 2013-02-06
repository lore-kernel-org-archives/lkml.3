Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617Ab3BFWXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:23:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37595 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758087Ab3BFWXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:23:14 -0500
Message-ID: <5112D7C0.7080009@zytor.com>
Date: Wed, 06 Feb 2013 14:22:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] x86: SGI UV3 Kernel Updates
References: <20130205222648.204965172@gulag1.americas.sgi.com>
In-Reply-To: <20130205222648.204965172@gulag1.americas.sgi.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 02:26 PM, Mike Travis wrote:
> Kernel updates for SGI Ultraviolet system 3 (UV3)
> 
> The new MMR definitions are added, and then the updates
> to each module are applied.  Afterwards, a "trim" patch
> reduces the size of the MMR definitions file by about
> a third.  This keeps "bi-sectability" in place.
> 

Can you please re-send this with proper formatting?  For one thing, all
your descriptions are indented.

	-hpa

