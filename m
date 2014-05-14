Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235AbaENSQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 14:16:04 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:59594 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaENSQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 14:16:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tony Lindgren <tony@atomide.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH] bus/omap_l3: avoid sync initcall for modules
Date: Wed, 14 May 2014 20:15:56 +0200
Message-ID: <5640589.bzCk17dFyc@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140514173931.GA14003@kroah.com>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de> <20140513162731.GD16837@atomide.com> <20140514173931.GA14003@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ctj3fjGFqS1nvCn+WfHkmPayChVho6SaQsknqY0OKrT
 0zm1VuL0cY6IMJaFxl2crm8yCKf0T9l1/9V3EqQjHc9vOzFVvJ
 7pjkCalu2BryzYd8JhM8MlJJUUM/6F7ev28bgcLtds4p3345GA
 1sk9P56FbUTwJzE6jo5TmZL1VpUwzNAN5iPBCLToNM2P27OYEw
 csQGz55KOWOH+UVs2e12zwALCMRwTwz1D2yAeAdBY/29s0qorB
 KlF7RVhkSaMdMOffvNLu3HPKVtmk2fIofCXMbPQpbj0vqm0sJq
 pyb+qD+JNkQ0icojyEg3+qXMdBPEbMbytWkhaw8A7w6I3DBpdA
 JoWw82MKiJDQSBvr4o3U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 May 2014 10:39:31 Greg KH wrote:
> On Tue, May 13, 2014 at 09:27:33AM -0700, Tony Lindgren wrote:
> > * Arnd Bergmann <arnd@arndb.de> [140513 08:13]:
> > 
> > I did not look what percentage has tristate in the Kconfig,
> > but that might keep some people from making loadable drivers.
> > 
> > Greg, is the following patch something you may want to
> > consider picking up?
> 
> Sure, is this needed to fix issues in 3.15-final, or is 3.16-rc1 ok?

I don't think anyone cares about it outside of randconfig builds,
so 3.16-rc1 is ok.

	Arnd
