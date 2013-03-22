Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab3CVToY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 15:44:24 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:21159 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110Ab3CVToX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 15:44:23 -0400
Message-ID: <514CB496.3080100@tilera.com>
Date: Fri, 22 Mar 2013 15:44:22 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        <linux-xtensa@linux-xtensa.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: remove KCORE_ELF again
References: <1363912851.1390.170.camel@x61.thuisdomein>
In-Reply-To: <1363912851.1390.170.camel@x61.thuisdomein>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/21/2013 8:40 PM, Paul Bolle wrote:
> The Kconfig symbol KCORE_ELF was removed in v2.6.0, but reappeared in two
> architectures. It is useless. Remove it again.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Untested.
>
> 1) Sent as one patch. Feel free to tell me to split it up in two
> patches.
>
>  arch/tile/Kconfig   |  5 -----
>  arch/xtensa/Kconfig | 15 ---------------
>  2 files changed, 20 deletions(-)

I took the tile part of this patch into the tile tree.  Thanks!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

