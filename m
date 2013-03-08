Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933764Ab3CHMj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 07:39:56 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:58332 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753315Ab3CHMjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 07:39:55 -0500
Message-ID: <1362746390.5994.62.camel@x61.thuisdomein>
Subject: Re: [PATCH] ARM: mach-bcm: drop "select GENERIC_TIME"
From: Paul Bolle <pebolle@tiscali.nl>
To: Christian Daudt <csd_b@daudt.org>
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 08 Mar 2013 13:39:50 +0100
In-Reply-To: <CAGFynZ-CBRMGAwgF+xjAU_R8QPHhS_wtQgxgmW9JPVsjohOi2w@mail.gmail.com>
References: <1362563553.16460.166.camel@x61.thuisdomein>
	 <CAGFynZ-CBRMGAwgF+xjAU_R8QPHhS_wtQgxgmW9JPVsjohOi2w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Mar 2013 12:39:50.0651 (UTC) FILETIME=[0694C4B0:01CE1BFA]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-07 at 19:18 -0800, Christian Daudt wrote:
> My bad. Thanks for the fix !
> 
> Reviewed-by: Christian Daudt <csd@broadcom.com>

In the same commit, 8ac49e0485bb79223a111b366a3b1f5ec9148729 ("Add
support for generic BCM SoC chipsets"), you also added
    select GPIO_BCM

There's currently no Kconfig symbol by that name. Is it perhaps needed
for future enhancements?


Paul Bolle

