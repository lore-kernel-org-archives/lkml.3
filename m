Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbaEVTpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 15:45:44 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:62794 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaEVTpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 15:45:43 -0400
Date: Thu, 22 May 2014 12:45:39 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH] dt/sparc: Introduce the use of the managed version of
 kzalloc
Message-ID: <20140522194539.GA7708@core.coreip.homeip.net>
References: <20140522193430.GA16315@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140522193430.GA16315@himangi-Dell>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Himangi,

On Fri, May 23, 2014 at 01:04:30AM +0530, Himangi Saraogi wrote:
> This patch moves data allocated using kzalloc to managed data allocated
> using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
> functions. Also the unnecessary labels are done away with.

Please no more partial devm conversions. I am not interested in patches
that change only 1 resource to be managed and leaving the rest as is.

If you want to do devm conversion please do it if you convert all (or at
least majority) of resource handling to managed resources.

...

> ---
> Not compiled due to incompatible architecture.
> 

There are cross-compilers that can be used to work around such issues.

Thanks.

-- 
Dmitry
