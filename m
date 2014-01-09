Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405AbaAIKP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 05:15:57 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:34732 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750851AbaAIKPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 05:15:49 -0500
Date: Thu, 9 Jan 2014 10:15:42 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Mark Salter <msalter@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, patches@linaro.org, linux-mm@kvack.org,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH v2 1/5] mm: create generic early_ioremap() support
Message-ID: <20140109101542.GD18441@console-pimps.org>
References: <1389062120-31896-1-git-send-email-msalter@redhat.com>
 <1389062120-31896-2-git-send-email-msalter@redhat.com>
 <52CC89B4.4060300@zytor.com>
 <1389197388.29144.37.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389197388.29144.37.camel@deneb.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Jan, at 11:09:48AM, Mark Salter wrote:
> 
> Ok, that sounds like a good idea. I'm uncertain how best to coordinate
> with Dave Young's patch series to avoid conflicts. His first patch does
> the signature change (and adds the early_memunmap function but that
> isn't used anywhere):
> 
>  https://lkml.org/lkml/2013/12/20/143
> 
> Any thoughts on how best to avoid potential merge conflicts here?

Dave's patch hasn't been picked up by anyone so far, so you could
incorporate it into your series.

-- 
Matt Fleming, Intel Open Source Technology Center
