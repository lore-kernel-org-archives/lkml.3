Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751147AbaLQSIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 13:08:04 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:59249 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaLQSIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 13:08:02 -0500
Date: Thu, 18 Dec 2014 02:07:56 +0800
From: Tsung-Han Lin <tsunghan.tw@gmail.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:board: fix build errors and warnings
Message-ID: <20141217180756.GA23742@Tari7Braves>
References: <1418059449-15108-1-git-send-email-tsunghan.tw@gmail.com>
 <20141212113610.C88F5C40872@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141212113610.C88F5C40872@trevor.secretlab.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 11:36:10AM +0000, Grant Likely wrote:
> On Tue,  9 Dec 2014 01:24:09 +0800
> , Tsung-Han Lin <tsunghan.tw@gmail.com>
>  wrote:
> > Add dummy implementation of 'of_find_all_nodes',
> > and remove the unnecessary 'of_can_translate_address',
> > which is already removed in commit
> > d9c6866be8a145e32da616d8dcbae806032d75b5 ("of: kill off
> > of_can_translate_address"), to fix the build errors and warnings
> > found by sparse.
> > 
> > Signed-off-by: Tsung-Han Lin <tsunghan.tw@gmail.com>
> 
> ???
> 
> This code is just weird. If CONFIG_OF is not enabled, then board.c
> shouldn't be compiled at all. You can do this with a patch to the
> Kconfig and Makefile. Also, if the functions in
> drivers/staging/board/board.c are needed for driver support, then please
> propose a patch that moves them in into drivers/of/base.c so that they
> can be reviewed properly. They are so short and simple that fixing them
> up as part of the normal review process should be sufficient.
> 
> As for fixing the compile error, please drop the change to
> include/linux/of.h and resubmit.
> 
> g.
> 
> 

Sorry it took me sometime to understand what I got wrong,
and thank you for your suggestion.
I will re-send a fix for this.

I just built those codes with wrong .config and options.
