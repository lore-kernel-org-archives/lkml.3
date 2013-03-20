Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934314Ab3CTCUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 22:20:19 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3230 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab3CTCUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 22:20:17 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 19 Mar 2013 19:20:08 -0700
Subject: Re: [PATCH] ARM: tegra: fuse: add fuctions to read speedo id and
 process id
From: Danny Huang <dahuang@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <514915DB.8060206@wwwdotorg.org>
References: <1363660405-10668-1-git-send-email-dahuang@nvidia.com>
	 <5148A8D6.8000002@wwwdotorg.org> <1363743557.3573.50.camel@dahuang-vm>
	 <514915DB.8060206@wwwdotorg.org>
Date: Wed, 20 Mar 2013 10:20:03 +0800
Message-ID: <1363746003.3573.80.camel@dahuang-vm>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-20 at 09:50 +0800, Stephen Warren wrote:
> On 03/19/2013 07:39 PM, Danny Huang wrote:
> > On Wed, 2013-03-20 at 02:05 +0800, Stephen Warren wrote:
> >> On 03/18/2013 08:33 PM, Danny Huang wrote:
> >>> Add functions to read the speedo and process id of both cpu and soc.
> >>> There might be some drivers need the information as well.
> >>
> >> What code wants to use these functions? It'd be best to submit this
> >> patch with that code, so that something actually uses the functions, and
> >> they don't look like dead code.
> > 
> > There are some developing drivers that are located in drivers folder
> > needs those information.
> 
> Which drivers?

Per my understanding, there is a dvfs development that is trying to use
the devfreq framework.

> 
> > I think that they can't include a header file in mach-tegra folder
> 
> True.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


