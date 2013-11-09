Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab3KIQMx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 11:12:53 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:61510 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab3KIQMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 11:12:52 -0500
Date: Sat, 9 Nov 2013 08:15:13 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Levente Kurusa <levex@linux.com>
Cc: Mark Brown <broonie@kernel.org>, Caizhiyong <caizhiyong@hisilicon.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>
Subject: Re: [PATCH] regmap: Fix compile warning with value uninitialized
Message-ID: <20131109161513.GD22695@kroah.com>
References: <C3050A4DBA34F345975765E43127F10F1C08B39E@szxeml512-mbs.china.huawei.com>
 <20131109151626.GT2493@sirena.org.uk>
 <527E55EF.5080504@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <527E55EF.5080504@linux.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 09, 2013 at 04:34:07PM +0100, Levente Kurusa wrote:
> 2013-11-09 16:16 keltezéssel, Mark Brown írta:
> > On Sat, Nov 09, 2013 at 09:49:11AM +0000, Caizhiyong wrote:
> > 
> >> @@ -2170,7 +2170,8 @@ int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
> >>  			  int num_regs)
> >>  {
> >>  	struct reg_default *p;
> >> -	int i, ret;
> >> +	int i;
> >> +	int ret = 0;
> >>  	bool bypass;
> Wouldn't the following be better?
> 
> int i, ret = 0;
> 
> I think it is more readable.

No, please put them on separate lines like the patch did.

