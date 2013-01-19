Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab3ASDZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 22:25:35 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47109 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab3ASDZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 22:25:33 -0500
Date: Sat, 19 Jan 2013 03:25:32 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de,
        Jonas Bonn <jonas.bonn@gmail.com>
Subject: Re: [PATCH v2 10/76] ARC: Fundamental ARCH data-types/defines
Message-ID: <20130119032532.GC23552@ZenIV.linux.org.uk>
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
 <1358511930-7424-11-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358511930-7424-11-git-send-email-vgupta@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 05:54:24PM +0530, Vineet Gupta wrote:

> +/* work to do on interrupt/exception return */
> +#define _TIF_WORK_MASK		(0x0000FFFF & ~_TIF_SYSCALL_TRACE)

Yuck...  Use the real set, please - there's future-proofing and then there's
leaving nasty minefields; this is the latter...
