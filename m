Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab3G3N4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:56:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40446 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801Ab3G3N4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:56:02 -0400
Date: Tue, 30 Jul 2013 06:57:20 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Mark Brown <broonie@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Driver core: Add accessor for device tree node
Message-ID: <20130730135720.GC27962@kroah.com>
References: <007601ce8d06$13dbb890$3b9329b0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <007601ce8d06$13dbb890$3b9329b0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 06:20:47PM +0900, Jingoo Han wrote:
> Add the wrapper function for retrieving device tree node instead of
> accessing dev->of_node directly.

Why?

