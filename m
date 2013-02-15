Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab3BOUKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 15:10:31 -0500
Received: from sauhun.de ([89.238.76.85]:41447 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263Ab3BOUKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 15:10:30 -0500
Date: Fri, 15 Feb 2013 21:10:24 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, swarren@nvidia.com,
        khali@linux-fr.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH] i2c: tegra: remove warning dump if timeout happen in
 transfer
Message-ID: <20130215201024.GH4351@the-dreams.de>
References: <1360845813-11334-1-git-send-email-ldewangan@nvidia.com>
 <20130215191826.GC4351@the-dreams.de>
 <511E8F3F.5010202@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511E8F3F.5010202@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 12:40:47PM -0700, Stephen Warren wrote:
> On 02/15/2013 12:18 PM, Wolfram Sang wrote:
> > On Thu, Feb 14, 2013 at 06:13:33PM +0530, Laxman Dewangan wrote:
> >> If timeout error occurs in the i2c transfer then it was dumping warning
> >> of call stack.
> >>
> >> Remove the warning dump as there is may be possibility that some slave
> >> devices are busy and not responding the i2c communication.
> >>
> >> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> > 
> > I'd like to have the patch extended. Currently, i2c-tegra is the only
> > I2C user of BUG and BUG_ON. Could you maybe extend the patch to handle
> > those situations more gracefully while we are at it? From a glimpse,
> > these situations don't need a complete halt of the kernel?
> 
> While that's probably useful, surely that's a separate patch?

Yes, can be argued. Patch applied to for-next, thanks!
