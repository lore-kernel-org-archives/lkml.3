Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660Ab3IKHSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 03:18:16 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:57608 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3IKHSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 03:18:15 -0400
X-IronPort-AV: E=Sophos;i="4.90,882,1371081600"; 
   d="scan'208";a="50348611"
Message-ID: <1378883893.3057.60.camel@dagon.hellion.org.uk>
Subject: Re: [PATCH] xen-netback: fix possible format string flaw
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Kees Cook <keescook@chromium.org>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <netdev@vger.kernel.org>
Date: Wed, 11 Sep 2013 08:18:13 +0100
In-Reply-To: <20130911043911.GA17237@www.outflux.net>
References: <20130911043911.GA17237@www.outflux.net>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-10 at 21:39 -0700, Kees Cook wrote:
> This makes sure a format string cannot accidentally leak into the
> kthread_run() call.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Ian Campbell <ian.campbell@citrix.com>

Thanks.

Ian.


