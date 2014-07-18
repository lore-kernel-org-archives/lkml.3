Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761196AbaGRJg1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:36:27 -0400
Received: from 1wt.eu ([62.212.114.60]:46110 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760904AbaGRJgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:36:25 -0400
Date: Fri, 18 Jul 2014 11:35:47 +0200
From: Willy Tarreau <w@1wt.eu>
To: Vincent Heuken <me@vincentheuken.com>
Cc: gregkh@linuxfoundation.org, armand.bastien@laposte.net, domdevlin@free.fr,
        monamagarwal123@gmail.com, julia.lawall@lip6.fr, arnd@arndb.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: panel: fixed frivilous else statement warning
Message-ID: <20140718093547.GB12232@1wt.eu>
References: <1404988468-8032-1-git-send-email-me@vincentheuken.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404988468-8032-1-git-send-email-me@vincentheuken.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 03:34:28AM -0700, Vincent Heuken wrote:
> Fixed one instance of the following checkpatch.pl warning in
> panel.c:
> WARNING: else is not generally useful after a break or return
> 
> Signed-off-by: Vincent Heuken <me@vincentheuken.com>

Acked-By: Willy Tarreau <w@1wt.eu>

Vincent, are you currently reviewing the driver ? We'd like someone
to completely review it to decide if it can be moved out of staging
or needs to be dropped (or fixed).

Thanks,
Willy

