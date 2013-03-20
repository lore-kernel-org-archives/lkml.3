Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656Ab3CTBjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 21:39:31 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12047 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416Ab3CTBja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 21:39:30 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 19 Mar 2013 18:32:09 -0700
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
In-Reply-To: <5148A8D6.8000002@wwwdotorg.org>
References: <1363660405-10668-1-git-send-email-dahuang@nvidia.com>
	 <5148A8D6.8000002@wwwdotorg.org>
Date: Wed, 20 Mar 2013 09:39:17 +0800
Message-ID: <1363743557.3573.50.camel@dahuang-vm>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-20 at 02:05 +0800, Stephen Warren wrote:
> On 03/18/2013 08:33 PM, Danny Huang wrote:
> > Add functions to read the speedo and process id of both cpu and soc.
> > There might be some drivers need the information as well.
> 
> What code wants to use these functions? It'd be best to submit this
> patch with that code, so that something actually uses the functions, and
> they don't look like dead code.

There are some developing drivers that are located in drivers folder
needs those information. I think that they can't include a header file
in mach-tegra folder. Hence I'd like to provide them such functions for
their development.
Is there any better way to do this?

> 
> In the past, functions similar to this used to exist. However, they were
> removed and replaced by direct access to the underlying variables. Do we
> actually need functions for this, or can code simply read from the
> variables instead?

