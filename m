Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab3DKT1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 15:27:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46485 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792Ab3DKT1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 15:27:12 -0400
Message-ID: <51670E51.6020106@zytor.com>
Date: Thu, 11 Apr 2013 12:26:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] x86, FPU: Fix FPU initialization
References: <1365436666-9837-1-git-send-email-bp@alien8.de> <20130410110840.GA29752@gmail.com> <20130410122411.GE13394@pd.tnic> <20130410122527.GB8686@gmail.com> <20130410133251.GC6857@pd.tnic> <516586CF.90909@zytor.com> <20130410161122.GI6857@pd.tnic> <20130410212950.GA6899@pd.tnic> <20130411120952.GA18879@gmail.com>
In-Reply-To: <20130411120952.GA18879@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2013 05:09 AM, Ingo Molnar wrote:
> 
> Even with this applied, the attached config is still unhappy and crashes/locks up 
> during user-space init, see the crashlog attached below.
> 
> The config has MATH_EMULATION=y, so I suspect it's the same problem category. 
> 

What host is this?

	-hpa


