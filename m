Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843Ab3FCPea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:34:30 -0400
Received: from smtp.citrix.com ([66.165.176.89]:14447 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756526Ab3FCPeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:34:24 -0400
X-IronPort-AV: E=Sophos;i="4.87,793,1363132800"; 
   d="scan'208";a="28900965"
Date: Mon, 3 Jun 2013 16:34:20 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>, <arnd@arndb.de>
Subject: Re: [PATCH v5 0/4] xen/arm: CONFIG_PARAVIRT and stolen ticks
 accounting
In-Reply-To: <alpine.DEB.2.02.1305301426520.4799@kaball.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1306031634050.4589@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305301426520.4799@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 May 2013, Stefano Stabellini wrote:
> I am starting to be pretty confident about this patch series.
> 
> Please advice on what tree I should use to get this stuff upstream: most
> of the changes are Xen specific, but it also contains few generic ARM
> changes (the introduction of CONFIG_PARAVIRT and paravirt.c on ARM) and
> a couple of lines in kernel/sched/cputime.c (a missing include).

ping?
