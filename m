Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab3FUJrb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 05:47:31 -0400
Received: from service87.mimecast.com ([91.220.42.44]:41965 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab3FUJr3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 05:47:29 -0400
Message-ID: <51C4212C.4030403@arm.com>
Date: Fri, 21 Jun 2013 10:47:24 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nico@fluxnic.net" <nico@fluxnic.net>,
        "cov@codeaurora.org" <cov@codeaurora.org>
Subject: Re: [PATCH v2 0/2] ARM: Remove any correlation between IPC and BogoMips
 value
References: <1371746612-23950-1-git-send-email-will.deacon@arm.com>
In-Reply-To: <1371746612-23950-1-git-send-email-will.deacon@arm.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 21 Jun 2013 09:47:25.0008 (UTC) FILETIME=[5578AD00:01CE6E64]
X-MC-Unique: 113062110472701901
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/06/13 17:43, Will Deacon wrote:
> Hi all,
> 
> This is version two of the patches I originally posted here:
> 
>   http://lists.infradead.org/pipermail/linux-arm-kernel/2013-May/166728.html
> 
> Comments received there largely confirmed that it's not possible to choose
> an `obviously bogus' value for BogoMIPs, so instead I've bitten the bullet
> and removed the line altogether.
> 
> In the meantime, I've only had one complaint this month about BogoMIPs
> being wrong, so perhaps the initial posting served some purpose without
> even being merged!

For the whole series, and cheering loudly:
Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...

