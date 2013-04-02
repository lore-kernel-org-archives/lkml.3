Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761572Ab3DBQkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:40:46 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:54810 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758662Ab3DBQkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:40:45 -0400
Date: Tue, 2 Apr 2013 09:40:42 -0700
From: Olof Johansson <olof@lixom.net>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, arm@kernel.org
Subject: Re: [PATCH 1/1] irqchip: irq-gic: Fix checkpatch errors
Message-ID: <20130402164042.GB25867@quad.lixom.net>
References: <1363167315-12753-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363167315-12753-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 03:05:15PM +0530, Sachin Kamat wrote:
> Fixes the following errors:
> ERROR: do not initialise statics to 0 or NULL
> ERROR: space required after that ',' (ctx:VxV)
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
> Compile tested and based on linux-next tree (20130313).

I haven't seen this show up in linux-next through Thomas, so I've applied it to
our next/cleanup branch.

Thanks.


-Olof

