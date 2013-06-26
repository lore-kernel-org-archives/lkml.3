Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab3FZI1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:27:35 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:47149 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab3FZI1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:27:33 -0400
Message-ID: <51CAA5F1.2010001@free-electrons.com>
Date: Wed, 26 Jun 2013 10:27:29 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the cpuinit tree with the arm-current
 tree
References: <20130626171241.4629f4072fbd36f12d5fe3be@canb.auug.org.au>
In-Reply-To: <20130626171241.4629f4072fbd36f12d5fe3be@canb.auug.org.au>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 09:12 AM, Stephen Rothwell wrote:
> Hi Paul,
> 
> Today's linux-next merge of the cpuinit tree got a conflict in arch/arm/mm/proc-v7.S between commit 3e0a07f8c401 ("ARM: 7773/1: PJ4B: Add support for errata 4742") from the arm-current
> tree and commit "arm: delete __cpuinit/__CPUINIT usage from all ARM users" from the cpuinit tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action is required).
> 
>From my point of view it looks good.
Thanks,
-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
