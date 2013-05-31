Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab3EaSOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 14:14:41 -0400
Received: from mail.candelatech.com ([208.74.158.172]:42345 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab3EaSOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 14:14:36 -0400
Message-ID: <51A8E884.1080009@candelatech.com>
Date: Fri, 31 May 2013 11:14:28 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: rusty@rustcorp.com.au, stable@kenel.org,
        Joe Lawrence <joe.lawrence@stratus.com>
Subject: Please add to stable:  module: don't unlink the module until we've
 removed all exposure.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It turns out, the bug I spent yesterday chasing in various 3.9 kernels is apparently
fixed by the commit in the title (c9c390bb5535380d40614571894ef0c00bc026ff).

Fortunately, Joe Lawrence somehow saw my email to lkml and pointed me to the
bug report below, which mentions the commit...

https://bugzilla.kernel.org/show_bug.cgi?id=58011


Please consider adding this patch to at least the 3.9 stable queue.

I have a kernel config larded up with debugging options that reproduces
the bug fairly quickly on stock 3.9.[01234] (Fedora-17, 64-bit, in case that matters)
if someone wants it....

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

