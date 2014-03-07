Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaCGLMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 06:12:10 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55002 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751359AbaCGLMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 06:12:07 -0500
Date: Fri, 7 Mar 2014 11:12:02 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: GIRISH K S <ks.giri@samsung.com>
Cc: Mark Brown <broonie@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH] spi/s3c64xx: Update DT binding documentation to
	match code
Message-ID: <20140307111202.GK8570@opensource.wolfsonmicro.com>
References: <4F.EF.24278.5C999135@epcpsbgx4.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F.EF.24278.5C999135@epcpsbgx4.samsung.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 10:04:53AM +0000, GIRISH K S wrote:
> Hello Charles, instead of the binding modification I shall
> handle it in the driver probe function by getting child
> node using the api of_get_child_by_name(child-node,
> "controller-data) and then use of_find_property to parse
> the cs-gpio.
>
> This looks like a better fix. Is that ok?

Sounds like a good solution to me.

Thanks,
Charles

