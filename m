Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab3AURXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:23:18 -0500
Received: from service87.mimecast.com ([91.220.42.44]:41765 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929Ab3AURXM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:23:12 -0500
Message-ID: <1358788988.6590.50.camel@hornet>
Subject: Re: [PATCH 10/15] mfd/vexpress: export
 vexpress_config_func_{put,get}
From: Pawel Moll <pawel.moll@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 21 Jan 2013 17:23:08 +0000
In-Reply-To: <1358788568-11137-11-git-send-email-arnd@arndb.de>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
	 <1358788568-11137-11-git-send-email-arnd@arndb.de>
X-Mailer: Evolution 3.6.2-0ubuntu0.1
Mime-Version: 1.0
X-OriginalArrivalTime: 21 Jan 2013 17:23:08.0258 (UTC) FILETIME=[FAF14420:01CDF7FB]
X-MC-Unique: 113012117231000501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-21 at 17:16 +0000, Arnd Bergmann wrote:
> The newly introduced vexpress mfd driver in linux-3.8-rc
> provides access to configuration functions, but the
> interfaces are not exported to modules, which breaks
> when the vexpress regulator driver tries to use them.
> 
> Without this patch, building allmodconfig results in:
> 
> ERROR: "__vexpress_config_func_get" [drivers/regulator/vexpress.ko] undefined!
> ERROR: "vexpress_config_func_put" [drivers/regulator/vexpress.ko] undefined!
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>

You are the third person noticing that. My bad :-(

In fact some other ones, like the *_bridge_register could do with
exporting as well... I'll get all the patches merged in my fixes branch
and send a pull request this week.

Thanks!

Paweł


