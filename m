Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab3DWKyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 06:54:50 -0400
Received: from intranet.asianux.com ([58.214.24.6]:41712 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab3DWKyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 06:54:49 -0400
X-Spam-Score: -100.8
Message-ID: <5176684A.2080600@asianux.com>
Date: Tue, 23 Apr 2013 18:54:02 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Arnd Bergmann <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>,
        Tony Lindgren <tony@atomide.com>, "olof@lixom.net" <olof@lixom.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM64: kernel: compiling issue, define cmpxchg64 and
 cmpxchg64_local for outside using.
References: <51712E5E.2020809@asianux.com> <201304191412.54601.arnd@arndb.de> <5171FD67.2080104@asianux.com> <2182812.ymprEm6XBb@wuerfel> <5174C5D9.3060109@asianux.com> <20130423104851.GC23407@arm.com>
In-Reply-To: <20130423104851.GC23407@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月23日 18:48, Catalin Marinas wrote:
> On Mon, Apr 22, 2013 at 06:08:41AM +0100, Chen Gang wrote:
>> > 
>> >   drivers use cmpxchg64, cmpxchg64_local ... to perform 64-bit operation,
>> >   so they can cross 32-bit and 64-bit platforms (it is a standard way).
>> > 
>> > 
>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
> Applied, thanks.


Thanks too. I should continue to find and make new patches for arm64.


-- 
Chen Gang

Asianux Corporation
