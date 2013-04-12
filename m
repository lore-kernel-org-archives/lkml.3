Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab3DLJNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 05:13:13 -0400
Received: from mail.abilis.ch ([195.70.19.74]:21534 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379Ab3DLJNH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 05:13:07 -0400
Date: Fri, 12 Apr 2013 11:12:35 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH] clk: Add device tree binding to clk-fixed-factor
Message-ID: <20130412091234.GC29291@ab42.lan>
References: <1365608443-30350-1-git-send-email-christian.ruppert@abilis.com>
 <51658BA9.7030508@free-electrons.com>
 <20130410162747.GG32603@ab42.lan>
 <20130411091952.GF8400@ab42.lan>
 <5166E41F.7060100@free-electrons.com>
 <20130412065417.GA29291@ab42.lan>
 <5167CE33.9010403@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <5167CE33.9010403@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 11:04:51AM +0200, Gregory CLEMENT wrote:
> On 04/12/2013 08:54 AM, Christian Ruppert wrote:
> > On Thu, Apr 11, 2013 at 06:26:07PM +0200, Gregory CLEMENT wrote:
> >> On 04/11/2013 11:19 AM, Christian Ruppert wrote:
> >>> Hi Gregory,
> >>>
> >>> Since there doesn't seem to be anyone opposing this feature I just
> >>> checked your patch and after adding the CLK_OF_DECLARE macro in the end
> >>> it works well for us. Tell me if you would like to rebase and resubmit
> >>> your patch or if I should follow up on our own.
> >>
> >> I can rebase and resubmit my patch, it's pretty straightforward.
> >> The problem was the lack of user in the kernel. And by user I mean
> >> a driver using these functions. Usually a new function enter in the
> >> kernel only if there are users for it inside the kernel so if you plan
> >> to submit a driver using this piece of code, then I see no reason
> >> to not get it.
> > 
> > If you add the line
> > 
> > CLK_OF_DECLARE(fixed_factor_clk, "fixed-factor-clkdiv", 
> 
> Why did you add the div suffix?
> 
> There is nothing in the function which prevent to have "mul" greater than
> "div" and hence having a multiplicative factor.
> 
> I think that this suffix is misleading.

You are right, let's remove it.

> [...]

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
