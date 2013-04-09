Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002Ab3DIEZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 00:25:44 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:42674 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761958Ab3DIEZn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 00:25:43 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <515DBE24.3090501@wwwdotorg.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, Simon Glass <sjg@chromium.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1365097717-11874-1-git-send-email-pdeschrijver@nvidia.com>
 <515DBE24.3090501@wwwdotorg.org>
Message-ID: <20130409042537.14359.94241@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH v9b 10/14] ARM: tegra: Define Tegra114 CAR binding
Date: Mon, 08 Apr 2013 21:25:37 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Warren (2013-04-04 10:53:40)
> On 04/04/2013 11:48 AM, Peter De Schrijver wrote:
> > The device tree binding models Tegra114 CAR (Clock And Reset) as a single
> > monolithic clock provider.
> > 
> > --
> > 
> > Mike,
> > 
> > This is a small binding doc update only. Hence I didn't make an entire new
> > patch series, but just an updated version of this patch. Please apply this
> > instead of '[PATCH v9 10/14] ARM: tegra: Define Tegra114 CAR binding'
> > (http://www.spinics.net/lists/linux-tegra/msg10910.html).
> > The rest of the series is not affected. 
> 
> I believe I was planning to take this series through the Tegra tree, so
> I'm more looking for Mikes ack than for him to apply this.
> 
> If that's changed, there are some other Tegra clock bug-fixes that'd
> benefit from moving to the clock tree.

I forgot to reply to this one last week with the rest of the v9 series.
This patch update also has my ack.

Regards,
Mike
