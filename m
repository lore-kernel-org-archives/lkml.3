Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab3BQWNY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 17:13:24 -0500
Received: from mail-ye0-f171.google.com ([209.85.213.171]:52432 "EHLO
	mail-ye0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab3BQWNX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:13:23 -0500
X-Greylist: delayed 692 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Feb 2013 17:13:23 EST
Date: Sun, 17 Feb 2013 16:05:17 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [v3 0/6] ARM: tegra: convert device tree files to use CLK
 defines
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: linux-tegra@vger.kernel.org, pdeschrijver@nvidia.com, pgaikwad@nvidia.com,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>, Simon Glass <sjg@chromium.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1360917814-27236-1-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1360917814-27236-1-git-send-email-hdoyu@nvidia.com> (from
	hdoyu@nvidia.com on Fri Feb 15 02:43:11 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1361138717.29465.2@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2013 02:43:11 AM, Hiroshi Doyu wrote:
> Hi,
> 
> With new dtc+cpp feature, we could get rid of magic numbers in dts*
> files. This patch replaces CLK IDs.
> 
> We also plan to share those DT header files with kernel source
> later[1].
...
> [1]  
> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-February/149804.html

This really smells like documentation should be updated, probably  
booting-without-of.txt or similar. Alas, I'm not capable of writing  
such an update...

Rob