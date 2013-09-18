Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab3IRGNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 02:13:38 -0400
Received: from mail-ye0-f179.google.com ([209.85.213.179]:34241 "EHLO
	mail-ye0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab3IRGNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 02:13:34 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: "memory" binding issues
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: devicetree@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        m.szyprowski@samsung.com, swarren@nvidia.com, rob.herring@calxeda.com
In-Reply-To: <1379371567.3721.46.camel@pasglop>
References: <1379300274.4098.77.camel@pasglop> <52372F2A.2050003@wwwdotorg.org> <1379371567.3721.46.camel@pasglop>
Date: Tue, 17 Sep 2013 18:38:23 -0700
Message-Id: <20130918013823.D617CC42C81@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Sep 2013 08:46:07 +1000, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> In anycase, just "/memory" will break on at least powerpc.

Ummm, really?

~/hacking/linux$ git grep 'memory {' arch/powerpc/boot/dts/* | wc -l
159
~/hacking/linux$ git grep 'memory@' arch/powerpc/boot/dts/* | wc -l
4

g.
