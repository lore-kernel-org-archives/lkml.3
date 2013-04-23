Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970Ab3DWSBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 14:01:53 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:39356 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756895Ab3DWSBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 14:01:52 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19+kOB0J9r6BEIQAM/TlSSN
Date: Tue, 23 Apr 2013 11:01:46 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Subject: Re: [PATCH 05/21] ARM: OMAP2+: add dependencies on ARCH_MULTI_V6/V7
Message-ID: <20130423180146.GI10155@atomide.com>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
 <1366734653-488286-6-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366734653-488286-6-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [130423 09:36]:
> CONFIG_ARCH_OMAP2PLUS depends on (ARCH_MULTI_V6 || ARCH_MULTI_V7) as of
> a0694861 "ARM: OMAP2+: Enable ARCH_MULTIPLATFORM support", but the
> individual OMAP2/3/4/5 and AM33XX platforms can all be selected independent
> of what we are building for, which is a bug and prevents us from easily
> building e.g. an ARMv7-only defconfig.
> 
> This makes ARCH_OMAP2 depend on ARCH_MULTI_V6 and the others depend on
> ARCH_MULTI_V7, to ensure we really only build the platforms for the
> CPUs we have enabled in the global multiplatform configuration step.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

Acked-by: Tony Lindgren <tony@atomide.com>

