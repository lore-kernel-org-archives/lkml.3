Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab3KNCji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 21:39:38 -0500
Received: from intranet.asianux.com ([58.214.24.6]:62338 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab3KNCj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 21:39:29 -0500
X-Spam-Score: -100.8
Message-ID: <5284385F.4030904@asianux.com>
Date: Thu, 14 Nov 2013 10:41:35 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Jonathan Austin <jonathan.austin@arm.com>,
        Al Viro <viro@zeniv.linux.org.uk>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: Re: [PATCH] arch: arm: uapi: be sure of "_UAPI" prefix for all guard
 macros
References: <527C5ECD.8010208@asianux.com>
In-Reply-To: <527C5ECD.8010208@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2013 11:47 AM, Chen Gang wrote:
> For all uapi headers, need use "_UAPI" prefix for its guard macro
> (which will be stripped by "scripts/headers_installer.sh").
> 
> Additional completions:
> 
>  - be sure that all "endif" need be appended related comment, also it
>    has and only has one empty line above and no any lines below either.
> 
>  - be sure that all normal uapi header files need content guard macro.
> 
>  - remove the default "kvm_para.h" which was added in Kbuild.

Oh, sorry, it should use 'generic-y' instead of 'header-y' in Kbuild. I
will send patch v2 for it.

> 
>  - remove the detail address of Free Software Foundation (or can not
>    pass "scripts/checkpatch.pl").
> 

Thanks.
-- 
Chen Gang
