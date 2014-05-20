Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbaETPUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 11:20:48 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:49991 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaETPUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 11:20:47 -0400
Date: Tue, 20 May 2014 08:20:43 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH] Input: misc : Introduce the use of the managed version
 of kzalloc
Message-ID: <20140520152042.GA9444@core.coreip.homeip.net>
References: <20140520150918.GA6269@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140520150918.GA6269@himangi-Dell>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Himangi,

On Tue, May 20, 2014 at 08:39:18PM +0530, Himangi Saraogi wrote:
> Would be better to add the definition of a
> devm_input_allocate_polled_device, like there is a
> devm_input_allocate_device defined?

There is one, queued for 3.16. You should see it in linux-next.

Thanks.

-- 
Dmitry
