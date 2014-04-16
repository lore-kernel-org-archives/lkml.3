Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbaDPSAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:00:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54471 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaDPSAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:00:49 -0400
Message-ID: <534EC54C.9080705@canonical.com>
Date: Wed, 16 Apr 2014 14:00:44 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linux-kernel@vger.kernel.org, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org, anton@samba.org
Subject: Re: [PATCH 1/1] powerpc: Increase COMMAND_LINE_SIZE to 2048 from
 512.
References: <cover.1397260361.git.joseph.salisbury@canonical.com>	 <84356b1cb9452226d54641a71e4b1363e78d4417.1397260362.git.joseph.salisbury@canonical.com>	 <534C2FEB.2000803@canonical.com> <1397555363.14218.6.camel@pasglop>
In-Reply-To: <1397555363.14218.6.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 05:49 AM, Benjamin Herrenschmidt wrote:
> On Mon, 2014-04-14 at 14:58 -0400, Joseph Salisbury wrote:
>> After further review, it appears ppc does not actually use the define
>> in
>> the ppc headers but uses the common generic
>> default(include/uapi/asm-generic/setup.h).  COMMAND_LINE_SIZE should
>> probably become a kernel config option.  Do folks agree that is the
>> correct thing to do?  If so, I can re-work the patch.
> No objection on my side.
>
> Make sure you remove any unused arch define while at it.
>
> Cheers,
> Ben.
>
>
Hi Ben,

I can think of two ways to add the new config option.  One would be to
have a large entry in ~/arch/Kconfig, with a default COMMAND_LINE_SIZE
line for each architecture.  The other way would be to have the default
value for COMMAND_LINE_SIZE in the architecture sub-directory Kconfig
file: ~/arch/powerpc/Kconfig for example.

Do you have a preference for either way?

Thanks,

Joe



