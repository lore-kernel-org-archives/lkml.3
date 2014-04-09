Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934264AbaDIUnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 16:43:25 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:49104 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933590AbaDIUnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 16:43:24 -0400
Date: Wed, 9 Apr 2014 21:43:12 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Thomas =?iso-8859-1?Q?B=E4chler?= <thomas@archlinux.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, matt.fleming@intel.com,
        ak@linux.intel.com, viro@zeniv.linux.org.uk, geert@linux-m68k.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, tpowa@archlinux.org, hpa@zytor.com
Subject: Re: 3.13: <module> disagrees about version of symbol <symbol>
Message-ID: <20140409204312.GK5222@console-pimps.org>
References: <53430646.40507@archlinux.org>
 <20140407204221.GW32556@tassilo.jf.intel.com>
 <CAL01qpvjZz-XnVT+S3E5E2XGcuFoetE5cwnArYfW-TwYZVKtKw@mail.gmail.com>
 <201404080646.BID87018.SOOVJMFOLFtQHF@I-love.SAKURA.ne.jp>
 <20140408121400.GI5222@console-pimps.org>
 <53444681.1070902@archlinux.org>
 <53445660.1010908@archlinux.org>
 <20140409082536.GJ5222@console-pimps.org>
 <5345051C.2060104@archlinux.org>
 <53458ADE.70000@archlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53458ADE.70000@archlinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Apr, at 08:01:02PM, Thomas Bächler wrote:
> 
> Hello again Matt,
> 
> that patch seems to help. Thank you so much.
> 
> (I am going to apply this patch and backport dc53324060, too, so
> everything should be in order then.)

That's great to hear, thanks for testing. I'll get this applied.

-- 
Matt Fleming, Intel Open Source Technology Center
