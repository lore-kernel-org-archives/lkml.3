Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933921Ab3BSSuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:50:46 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:35073 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933907Ab3BSSum convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:50:42 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <5123C6E7.9070407@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, Simon Glass <sjg@chromium.org>,
        Joseph Lo <josephl@nvidia.com>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1360931849-7090-1-git-send-email-pdeschrijver@nvidia.com>
 <5123C6E7.9070407@wwwdotorg.org>
Message-ID: <20130219185034.27993.86892@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH v7 00/12] Tegra114 clockframework
Date: Tue, 19 Feb 2013 10:50:34 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Warren (2013-02-19 10:39:35)
> On 02/15/2013 05:36 AM, Peter De Schrijver wrote:
> > This is the seventh version of the Tegra114 clockframework. It is based on the
> > for-next branch of
> > git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-tegra.git and
> > http://www.spinics.net/lists/arm-kernel/msg220452.html.
> 
> Mike,
> 
> I think it'd be prudent to take this series through the Tegra tree again
> for 3.10; patch 11 needs to go in as part of the series due to internal
> dependencies, and I'm slightly worried that other Tegra DT changes might
> conflict with that patch (if only for context). Taking this series (and
> any other Tegra clk driver changes for 3.10) through the Tegra tree
> could resolve that easily. Do you have a problem with that?
> 

I was thinking the same thing.  I'll make time to review these now that
3.8 is out.

> If that's OK, can you stage the dependency Peter mentioned:
> http://www.spinics.net/lists/arm-kernel/msg220452.html
> into a stable branch for me to merge, obviously after 3.9-rc1 is out.
> 

I'll take another look at that one.  I haven't merged it yet for some
reason but I've forgotten why.  Assuming nothing is wrong then I'll pull
it in towards 3.10.

Regards,
Mike

> Thanks.
> 
> Prashant, could you provide a review/ack for this series too.
