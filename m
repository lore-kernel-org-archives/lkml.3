Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbaHUTby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 15:31:54 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:54049 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbaHUTbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 15:31:52 -0400
Date: Thu, 21 Aug 2014 14:31:41 -0500
From: Tejun Heo <tj@kernel.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, thierry.reding@gmail.com,
        linux-ide@vger.kernel.org, linux-tegra@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ata: ahci: tegra: fix build error
Message-ID: <20140821193141.GA6168@mtj.dyndns.org>
References: <20140821190824.GM11146@saruman.home>
 <53F645BA.4000402@wwwdotorg.org>
 <20140821192134.GO11146@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140821192134.GO11146@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Aug 21, 2014 at 02:21:34PM -0500, Felipe Balbi wrote:
> > I wonder if libata/for-3.17-fixes isn't in linux-next?
> 
> it is, it's just that I was build testing my branch which is based off
> of v3.17-rc1 as of now.

Yeah, I'm traveling and haven't had the chance to push it.  I'll try
to push it right now.

Thanks.

-- 
tejun
