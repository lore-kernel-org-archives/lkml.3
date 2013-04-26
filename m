Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab3DZPIE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 11:08:04 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56826 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3DZPID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 11:08:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 01/21] ARM: topology: export cpu_topology
Date: Fri, 26 Apr 2013 17:07:57 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de> <1366910944-3033663-2-git-send-email-arnd@arndb.de> <20130426085333.GA30284@mudshark.cambridge.arm.com>
In-Reply-To: <20130426085333.GA30284@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304261707.57328.arnd@arndb.de>
X-Provags-ID: V02:K0:22ZG0S3FU7FkozVmMFHx24PJW4Ik2suZHv03JsyNQCP
 c5j+uQ+Q0jECKuUQlDHiVo4nlbXtPpo77sEtORH8VxVCCy8pLk
 yywgvS/GK2EPX6zGhKkyV6IYYlT3GoaZr7GozhOZW1edAEB/8n
 Yca2f0TOmEPGTFdjPuxg4L66spTlG9n9Z/mZBZqAmjXrX5fJta
 hkb31FZJd6vGTikfowtli6z3DH+PBS49I/jshDMe62d6bb1CAp
 siabQVjcDqOie6VvgU4O0BZKSR8vfCox4R0Fr/u3LxuYFEXuO6
 tTk05D1SVXYPHmxfbzOfXZQzGnfilxAmvxhBcjRrnLL8KV5/ZS
 6t3ELWpJayZEnqZUXERY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 April 2013, Will Deacon wrote:
> On Thu, Apr 25, 2013 at 06:28:44PM +0100, Arnd Bergmann wrote:
> > The cpu_topology symbol is required by any driver using the topology
> > interfaces, which leads to a couple of build errors:
> > 
> > ERROR: "cpu_topology" [drivers/net/ethernet/sfc/sfc.ko] undefined!
> > ERROR: "cpu_topology" [drivers/cpufreq/arm_big_little.ko] undefined!
> 
> Are these first two in mainline?

I think they are both newly added in linux-next.

	Arnd
