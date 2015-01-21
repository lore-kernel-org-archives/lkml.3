Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbbAUVYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 16:24:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35830 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbbAUVYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 16:24:09 -0500
Date: Wed, 21 Jan 2015 22:24:07 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Michal Marek <mmarek@suse.cz>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: Use Kbuild idiom in Makefiles
In-Reply-To: <1421845630-25431-1-git-send-email-mmarek@suse.cz>
Message-ID: <alpine.LNX.2.00.1501212223280.10817@pobox.suse.cz>
References: <1421845630-25431-1-git-send-email-mmarek@suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015, Michal Marek wrote:

> Use <driver>-$(CONFIG_FOO) syntax to build multipart objects with
> optional parts, since all the config options are bool. Also, delete the
> obvious comments in the usbhid Makefile.
> 
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  drivers/hid/Makefile        | 49 +++++++++++----------------------------------
>  drivers/hid/usbhid/Makefile | 12 ++---------
>  2 files changed, 14 insertions(+), 47 deletions(-)

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
