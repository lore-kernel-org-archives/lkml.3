Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab3IYJdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 05:33:24 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:64612 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab3IYJdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 05:33:23 -0400
Date: Wed, 25 Sep 2013 11:33:20 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] printk: report console names during cut-over
Message-ID: <20130925093318.GA2317@localhost.localdomain>
References: <20130923213523.GA23478@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130923213523.GA23478@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 02:35:24PM -0700, Kees Cook wrote:
> This reports the names of consoles as they're being disabled to help
> identify which is which during cut-over. Helps answer the question
> "which boot console actually got activated?" once the regular console
> is running, mostly when debugging boot console failures.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks!
