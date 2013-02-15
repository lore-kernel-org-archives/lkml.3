Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284Ab3BOTSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 14:18:31 -0500
Received: from sauhun.de ([89.238.76.85]:55648 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755Ab3BOTS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 14:18:29 -0500
Date: Fri, 15 Feb 2013 20:18:26 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: swarren@nvidia.com, khali@linux-fr.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH] i2c: tegra: remove warning dump if timeout happen in
 transfer
Message-ID: <20130215191826.GC4351@the-dreams.de>
References: <1360845813-11334-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360845813-11334-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 06:13:33PM +0530, Laxman Dewangan wrote:
> If timeout error occurs in the i2c transfer then it was dumping warning
> of call stack.
> 
> Remove the warning dump as there is may be possibility that some slave
> devices are busy and not responding the i2c communication.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

I'd like to have the patch extended. Currently, i2c-tegra is the only
I2C user of BUG and BUG_ON. Could you maybe extend the patch to handle
those situations more gracefully while we are at it? From a glimpse,
these situations don't need a complete halt of the kernel?

Thanks,

   Wolfram

