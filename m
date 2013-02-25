Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759802Ab3BYXdw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 18:33:52 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:53506 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759567Ab3BYXdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 18:33:50 -0500
Date: Mon, 25 Feb 2013 15:33:45 -0800
From: "'Tejun Heo'" <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH] rtc: add devm_rtc_device_{register,unregister}()
Message-ID: <20130225233345.GB2679@htj.dyndns.org>
References: <000e01ce132a$be08b940$3a1a2bc0$%han@samsung.com>
 <20130225142957.8e4aca8a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130225142957.8e4aca8a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 02:29:57PM -0800, Andrew Morton wrote:
> > + * Managed rtc_device_register(). The rtc_device returned from this function
> > + * are automatically freed on driver detach. See rtc_device_register()
> > + * for more information.
> > + */
> 
> I think the name is inappropriate.  devm functions start with "devm"
> and rtc functions start with "rtc" and this code is a part of rtc core,
> not a part of devm core.  Hence it should be something like
> "rtc_devm_device_register".

I think devm_rtc_ is better.  All other devm interface functions put
devm_ prefix first and I think it's better to make devm_ more
pronounced as it denotes a somewhat subtle difference in behavior.

Thanks.

-- 
tejun
