Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaBKQAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:00:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59572 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbaBKQAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:00:10 -0500
Message-ID: <52FA4901.8030405@infradead.org>
Date: Tue, 11 Feb 2014 08:00:01 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>, Jiri Kosina <trivial@kernel.org>
CC: Martin Walch <walch.martin@web.de>, Richard Weinberger <richard@nod.at>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] Kconfig: Remove useless "default N" lines
References: <1392122327.13064.14.camel@x220>
In-Reply-To: <1392122327.13064.14.camel@x220>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2014 04:38 AM, Paul Bolle wrote:
> A number of Kconfig entries default to (uppercase) "N". It was clearly
> intended to use "default n". But since (lowercase) "n" is the default
> anyway, these lines might as well be removed.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Tested on a Fedora 20-based .config, where it was a NOP. But there's a
> chance that none of the entries I touch here influence that .config. I
> didn't check.
> 
> This patch deserves a
>     Reported-by: Martin Walch <walch.martin@web.de>
> 
> line, but that apparently requires Martin's permission.

I've never heard that. Did you read that somewhere? If so, where?

I think that copying him on the patch is sufficient.

thanks,
-- 
~Randy
