Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393Ab3HTHrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 03:47:53 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47559 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab3HTHrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 03:47:52 -0400
Date: Tue, 20 Aug 2013 08:47:47 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] mfd: max8997: use devm_*() functions
Message-ID: <20130820074747.GG23699@lee--X1>
References: <005501ce9d73$5abdef80$1039ce80$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <005501ce9d73$5abdef80$1039ce80$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Use devm_*() functions to make cleanup paths simpler.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Patches look good to me 1-6 applied.

By the way, when you're sending patch-sets would you mind adding a
cover letter? Or at least thread patches 2-n on to patch 1. It just
makes them easier to track if they receive comments.

If you don't already, send your patches with `git send-mail` and try
playing around with: --thread (turns on threading) and
--[no-]chain-reply-to (controlls shallow and deep threading) to find
your preference. Cover letters are added with --compose and for
convenience you can annotate them with, surprise surprise --annotate. :)

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
