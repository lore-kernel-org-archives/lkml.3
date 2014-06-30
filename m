Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbaF3Tny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 15:43:54 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:43430 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaF3Tnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 15:43:52 -0400
Date: Mon, 30 Jun 2014 21:43:46 +0200
From: Rabin Vincent <rabin@rab.in>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mike Turquette <mturquette@linaro.org>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 3/5] clk: use struct clk only for external API
Message-ID: <20140630194311.GA5167@dator>
References: <1403855872-14749-1-git-send-email-tomeu.vizoso@collabora.com>
 <1403855872-14749-4-git-send-email-tomeu.vizoso@collabora.com>
 <53ADF239.9050008@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53ADF239.9050008@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 04:37:45PM -0600, Stephen Warren wrote:
> On 06/27/2014 01:57 AM, Tomeu Vizoso wrote:
> > +struct clk {
> > +	struct clk_core clk;
> > +};
> 
> I'm confused why that field isn't a pointer instead.

It becomes a pointer in the following patch.

It's been a while since I created these patches, but IIRC I split it
this way because this patch was large and touching several drivers and
thus I wanted to make it do just the rename and keep core changes to a
minimum.  Such as step may not be needed with Tomeu's series since it's
organized differently.
