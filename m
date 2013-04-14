Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab3DNR0j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 13:26:39 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:40280 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752117Ab3DNR0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 13:26:38 -0400
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] ARM: KVM: Add missing break;
X-PHP-Originating-Script: 0:func.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sun, 14 Apr 2013 19:26:25 +0200
From: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <cdall@cs.columbia.edu>,
        Marcelo Tosatti <mtosatti@redhat.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Organization: ARM Ltd
In-Reply-To: <1365918945.1878.8.camel@joe-AO722>
References: <1365917315-3615-1-git-send-email-linux@prisktech.co.nz> <1365918945.1878.8.camel@joe-AO722>
Message-ID: <d57c84379b08873899ad0bcf95848fa7@localhost>
User-Agent: RoundCube Webmail/0.3.1
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: joe@perches.com, cdall@cs.columbia.edu, mtosatti@redhat.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Sat, 13 Apr 2013 22:55:45 -0700, Joe Perches <joe@perches.com> wrote:
> commit 3401d54696f ("KVM: ARM: Introduce KVM_ARM_SET_DEVICE_ADDR ioctl")
> added the case, but omitted adding break;

[...]

Already reported here:
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-April/160127.html

> $ grep -rP --include=*.[ch]
> "\b(\w+)\s*=[^;]+;\s*(?:case\s+\w+:|default:)\s*\1\s*="

Cool regexp! :-)
 
Cheers,

        M.
-- 
Fast, cheap, reliable. Pick two.
