Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab3BFPf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 10:35:29 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:59096 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756309Ab3BFPf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 10:35:28 -0500
Date: Wed, 6 Feb 2013 19:35:24 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: akpm@linux-foundation.org, keescook@chromium.org,
        serge.hallyn@canonical.com, ebiederm@xmission.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, marcel@holtmann.org
Subject: Re: [PATCH] kernel: arg2 is unsigned long which is never < 0
Message-ID: <20130206153524.GU1712@moon>
References: <511217F3.6050800@asianux.com>
 <20130206085653.GQ1712@moon>
 <51123236.3060001@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51123236.3060001@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 06:36:38PM +0800, Chen Gang wrote:
...
> 
> result:
>   still use the macros of branch 1
>   and use branch 1 macros instead of branch 2 macros (need an additional patch).

Oh, what a mess ;) The reason I used SUID_DUMPABLE_DISABLED -- because
it's used in set_dumpable which is called directly from this prctl.
I'm fine with either way, plain [0;1] is acceptable as well still
I don;t like it.
