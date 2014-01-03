Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbaACLTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 06:19:50 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:62056 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaACLTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 06:19:34 -0500
MIME-Version: 1.0
In-Reply-To: <1387891931-9854-5-git-send-email-pdeschrijver@nvidia.com>
References: <1387891931-9854-1-git-send-email-pdeschrijver@nvidia.com> <1387891931-9854-5-git-send-email-pdeschrijver@nvidia.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 3 Jan 2014 20:19:12 +0900
Message-ID: <CAAVeFuJ2i6N-=bGqjTZNmgD3iT-7vSxaWze+QFLbf4jjhU7dNA@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] ARM: tegra: rework fuse.c
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Olof Johansson <olof@lixom.net>, Danny Huang <dahuang@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 10:32 PM, Peter De Schrijver
<pdeschrijver@nvidia.com> wrote:
> Reduce fuse.c to the minimum functionality required for the early bootstages.
> Also export tegra_read_straps() for use by the fuse driver.
>
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

Fine with this since the fuse clock is still explicitly enabled during init.

Acked-by: Alexandre Courbot <acourbot@nvidia.com>
