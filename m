Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab3IYMvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:51:47 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:58982 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737Ab3IYMvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:51:43 -0400
Date: Wed, 25 Sep 2013 13:51:39 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 2/3] mfd: mc13xxx: Move SPI erratum workaround into SPI
 I/O function
Message-ID: <20130925125139.GJ5132@lee--X1>
References: <1379960073-23245-1-git-send-email-broonie@kernel.org>
 <1379960073-23245-2-git-send-email-broonie@kernel.org>
 <20130925111954.GG5132@lee--X1>
 <20130925113103.GN3226@sirena.org.uk>
 <20130925114643.GH5132@lee--X1>
 <20130925115502.GI5132@lee--X1>
 <20130925123536.GO3226@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130925123536.GO3226@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Sep 2013, Mark Brown wrote:

> On Wed, Sep 25, 2013 at 12:55:02PM +0100, Lee Jones wrote:
> 
> > https://git.linaro.org/gitweb?p=people/ljones/mfd.git mfd-asoc
> 
> Thanks, could you include the first patch as well please (there's a
> dependency for bisection due to the BUG_ONs)? 

Okay, done. Same branch.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
