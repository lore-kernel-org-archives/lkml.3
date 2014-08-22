Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbaHVJsg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 05:48:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52044 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755403AbaHVJsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 05:48:35 -0400
Date: Fri, 22 Aug 2014 10:48:32 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: kbuild test robot <fengguang.wu@intel.com>,
        Mark Brown <broonie@linaro.org>, kbuild-all@01.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: wm8994: Export symbols ready for built-in =>
	modular build
Message-ID: <20140822094832.GE7328@opensource.wolfsonmicro.com>
References: <53f62a3b.Rzd7pzhWx4p+Vvnr%fengguang.wu@intel.com> <20140822094458.GV4266@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140822094458.GV4266@lee--X1>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 10:44:58AM +0100, Lee Jones wrote:
> We'd like to be able to build the WM8994 family as modules, but the
> build will fail if the external symbols aren't exported first.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 

Acked-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Thanks,
Charles
