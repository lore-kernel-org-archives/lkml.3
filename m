Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241Ab3BWVeH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 16:34:07 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:48993 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759309Ab3BWVdl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 16:33:41 -0500
Date: Sat, 23 Feb 2013 13:51:14 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [v3 0/6] ARM: tegra: convert device tree files to use CLK
 defines
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Hiroshi Doyu <hdoyu@nvidia.com>, linux-tegra@vger.kernel.org,
        pdeschrijver@nvidia.com, pgaikwad@nvidia.com,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>, Simon Glass <sjg@chromium.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1360917814-27236-1-git-send-email-hdoyu@nvidia.com>
	<1361138717.29465.2@driftwood> <5123B1F8.4040102@wwwdotorg.org>
In-Reply-To: <5123B1F8.4040102@wwwdotorg.org> (from swarren@wwwdotorg.org on
	Tue Feb 19 11:10:16 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1361649074.11282.12@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 11:10:16 AM, Stephen Warren wrote:
> On 02/17/2013 03:05 PM, Rob Landley wrote:
> > On 02/15/2013 02:43:11 AM, Hiroshi Doyu wrote:
> >> Hi,
> >>
> >> With new dtc+cpp feature, we could get rid of magic numbers in dts*
> >> files. This patch replaces CLK IDs.
> >>
> >> We also plan to share those DT header files with kernel source
> >> later[1].
> > ...
> >> [1]
> >>  
> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-February/149804.html
> >>
> >
> > This really smells like documentation should be updated, probably
> > booting-without-of.txt or similar. Alas, I'm not capable of writing  
> such
> > an update...
> 
> I'm not sure what documentation would be updated nor why. Can you
> describe that?

"When writing new device tree files, please do not include magic  
numbers. Here's how to avoid them."

Does something in Documentation already say this somewhere?

Rob

