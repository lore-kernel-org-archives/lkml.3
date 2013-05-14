Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab3ENQM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:12:56 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33716 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab3ENQMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:12:55 -0400
Message-ID: <51926283.7010401@wwwdotorg.org>
Date: Tue, 14 May 2013 10:12:51 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laurent Navet <laurent.navet@gmail.com>
CC: broonie@kernel.org, grant.likely@linaro.org,
        spi-devel-general@lists.sourceforge.net, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH] drivers/spi/spi-tegra114.c clean use of devm_ioremap_resource()
References: <1368526032-31371-1-git-send-email-laurent.navet@gmail.com>
In-Reply-To: <1368526032-31371-1-git-send-email-laurent.navet@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 04:07 AM, Laurent Navet wrote:
> Check of 'r' and calls to dev_err are already done in devm_ioremap_resource,
> so no need to do them twice.

I think this duplicates part of a much wider patch series that Wolfram
is working on; I CC'd him here.
