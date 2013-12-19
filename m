Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab3LSTcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 14:32:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34781 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab3LSTcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 14:32:07 -0500
Message-ID: <52B349B5.6090200@infradead.org>
Date: Thu, 19 Dec 2013 11:32:05 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org, target-devel <target-devel@vger.kernel.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: linux-next: Tree for Dec 19 (target)
References: <20131219165106.73f28ea8aa1bd059423cb5f8@canb.auug.org.au>
In-Reply-To: <20131219165106.73f28ea8aa1bd059423cb5f8@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/13 21:51, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20131218:
> 


on i386:

drivers/built-in.o: In function `target_alua_state_check':
(.text+0x3fc859): undefined reference to `__udivdi3'




-- 
~Randy
