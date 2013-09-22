Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab3IVIKM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 04:10:12 -0400
Received: from science.horizon.com ([71.41.210.146]:30018 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752286Ab3IVIKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 04:10:04 -0400
Date: 22 Sep 2013 04:09:59 -0400
Message-ID: <20130922080959.384.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: jslaby@suse.cz, keescook@chromium.org, penguin-kernel@I-love.SAKURA.ne.jp
Subject: Re: [PATCH 1/2] remove all uses of printf's %n
Cc: akpm@linux-foundation.org, dan.carpenter@oracle.com, geert@linux-m68k.org,
        JBeulich@suse.com, joe@perches.com, kosaki.motohiro@gmail.com,
        linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
        linux@horizon.com, netdev@vger.kernel.org,
        remi.denis-courmont@nokia.com, viro@zeniv.linux.org.uk,
        xemul@openvz.org
In-Reply-To: <201309210928.JCF90671.OtOFLFQSOJVFMH@I-love.SAKURA.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you want, we can rename seq_pad() to seq_pad_and_putc(). Also we can pass
> both the padding character (e.g. ' ') and the trailing character (e.g. '\n')
> like seq_pad_and_putc((' ' << 8) | '\n'), though I wonder someone wants to
> use '\0', '\t', '\n' etc. as the padding character...

How about let that complexity wait until it's needed?  It's not like
it's that big a PITA of a patch to write, and there's a significant
chance it will *never* be needed.
