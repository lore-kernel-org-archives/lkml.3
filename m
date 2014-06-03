Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470AbaFCSOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:14:24 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:39374 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752113AbaFCSOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:14:22 -0400
X-IronPort-AV: E=Sophos;i="4.98,967,1392159600"; 
   d="scan'208";a="77879928"
Date: Tue, 3 Jun 2014 20:14:19 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Stephen Boyd <sboyd@codeaurora.org>
cc: Julia Lawall <julia.lawall@lip6.fr>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org,
        Mitchel Humpherys <mitchelh@codeaurora.org>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v2] coccinelle: Check for missing NULL terminators in
 of_device_id tables
In-Reply-To: <538E09C1.30200@codeaurora.org>
Message-ID: <alpine.DEB.2.02.1406032013150.2009@localhost6.localdomain6>
References: <1401213858-31950-1-git-send-email-sboyd@codeaurora.org> <alpine.DEB.2.02.1406031208380.2036@localhost6.localdomain6> <538E09C1.30200@codeaurora.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2014, Stephen Boyd wrote:

> On 06/03/14 03:15, Julia Lawall wrote:
> > Failure to terminate an of_device_id table can lead to confusing
> > failures depending on where the compiler places the array. Add a
> > check to make sure these tables are terminated. Thanks to Mitchel
> > Humpherys for coming up with the pattern initially.
> >
> > Cc: Mitchel Humpherys <mitchelh@codeaurora.org>
> > Cc: Julia Lawall <Julia.Lawall@lip6.fr>
> > Cc: Gilles Muller <Gilles.Muller@lip6.fr>
> > Cc: Nicolas Palix <nicolas.palix@imag.fr>
> > Cc: Grant Likely <grant.likely@linaro.org>
> > Cc: Rob Herring <robh+dt@kernel.org>
> > Cc: devicetree@vger.kernel.org
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> > Acked-by: Grant Likely <grant.likely@linaro.org>
> > Signed-off-by: Julia Lawall <julia.lawall@lip6.fr>
> >
> > ---
> >
> > v3: Removed unneeded rule bad_of_table.  Placed * in context rule on the 
> > closing brace; putting it on the field caused all fields to be marked.
> >
> 
> 
> These seem like only minor changes. Why was my authorship removed?

Probably because I don't know how to provide a new vesion of the patch 
properly.  What should I have done?  There were quite a lot of 
modifications.  It seemed easier to just send a complete new version.

julia
