Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbaBZU25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:28:57 -0500
Received: from mail.candelatech.com ([208.74.158.172]:54796 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbaBZU24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:28:56 -0500
Message-ID: <530E4E88.5040105@candelatech.com>
Date: Wed, 26 Feb 2014 12:28:56 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Build failure related to 'spinlokk_types.h'
References: <530E4599.1030700@candelatech.com>
In-Reply-To: <530E4599.1030700@candelatech.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 11:50 AM, Ben Greear wrote:
> This is from the ath10k tree, which was recently rebased on top of
> 3.14.0-rc4.
> 
> I'm getting the error below, but I cannot find any reference to 'spinlokk'
> in the source tree.  The build tree has two mentions, but these are auto-generated
> from what I can tell:
> 
> [greearb@ben-dt2 linux-ath.x64]$ grep -r spinlokk .
> ./arch/x86/kernel/cpu/.common.o.tmp:  /mnt/sda/home/greearb/git/linux.ath/include/linux/spinlokk_types.h \
> ./arch/x86/kernel/cpu/.common.o.d: /mnt/sda/home/greearb/git/linux.ath/include/linux/spinlokk_types.h \
> [greearb@ben-dt2 linux-ath.x64]$

Looks like it was a .ccache issue...I removed it and re-built and it was
fine...

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

