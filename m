Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773Ab3IBOua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 10:50:30 -0400
Received: from smtp-out-219.synserver.de ([212.40.185.219]:1136 "EHLO
	smtp-out-211.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758588Ab3IBOu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 10:50:29 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 9666
Message-ID: <5224A616.2060501@metafoo.de>
Date: Mon, 02 Sep 2013 16:52:06 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130827 Icedove/17.0.8
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: dma_slave_caps: remove sg entries
References: <1378124519-13900-1-git-send-email-vinod.koul@intel.com>
In-Reply-To: <1378124519-13900-1-git-send-email-vinod.koul@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2013 02:21 PM, Vinod Koul wrote:
> As pointed by Russell in [1], the sg properties are already availble in struct device,
> so no need to duplicate here.
> 
> [1]: http://marc.info/?l=linux-omap&m=137416733628831

Hm, I guess that will work as well, but shouldn't we update the drivers that
already implementing this interface first?

- Lars
