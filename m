Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474Ab3FMWxJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 18:53:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:59127 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756256Ab3FMWxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 18:53:08 -0400
Message-ID: <1371163963.5555.25.camel@pasglop>
Subject: Re: [GIT PULL] devicetree bugfixes for v3.10
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Stephen Warren <SWarren@nvidia.com>
Date: Fri, 14 Jun 2013 08:52:43 +1000
In-Reply-To: <CACxGe6sE5qm5CmGxO8p1dR9v7bbqipm5pYRz8F6pQdWVHetCgA@mail.gmail.com>
References: <CACxGe6sE5qm5CmGxO8p1dR9v7bbqipm5pYRz8F6pQdWVHetCgA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-13 at 23:22 +0100, Grant Likely wrote:
> Grant Likely (2):
>       dtc: Update generated files to output from Bison 2.5
>       dtc: ensure #line directives don't consume data from the next 

Question. Are those fixes also in the upstream dtc from jdl ? Or have we
effectively forked it ?

Cheers,
Ben.


