Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbaJQHpy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 03:45:54 -0400
Received: from smtp-out-106.synserver.de ([212.40.185.106]:1044 "EHLO
	smtp-out-106.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaJQHpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 03:45:53 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 24372
Message-ID: <5440C929.9050906@metafoo.de>
Date: Fri, 17 Oct 2014 09:45:45 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.8.1
MIME-Version: 1.0
To: Ray Jui <rjui@broadcom.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
CC: Scott Branden <sbranden@broadcom.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: pl330: use subsys_initcall
References: <Ray Jui <rjui@broadcom.com> <1413506896-4536-1-git-send-email-rjui@broadcom.com>
In-Reply-To: <1413506896-4536-1-git-send-email-rjui@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2014 02:48 AM, Ray Jui wrote:
> As part of subsystem that many slave drivers depend on, it's more
> appropriate for the pl330 DMA driver to be initialized at
> subsys_initcall than device_initcall

Well, we do have -EPROBE_DEFER these days to handle these kinds of 
dependencies so we no longer have to these kinds of manual init reordering 
tricks.

- Lars
