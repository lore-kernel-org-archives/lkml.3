Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab3D0TLd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 15:11:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40532 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894Ab3D0TLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 15:11:31 -0400
Date: Sat, 27 Apr 2013 21:11:29 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Simon Wood <simon@mungewell.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        djovic78@gmail.com, madcatxster@gmail.com
Subject: Re: [PATCH] HID: hid-lg4ff add support for new version of DFGT
 wheel
In-Reply-To: <1367026194-2103-1-git-send-email-simon@mungewell.org>
Message-ID: <alpine.LNX.2.00.1304272111170.17743@pobox.suse.cz>
References: <1367026194-2103-1-git-send-email-simon@mungewell.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Apr 2013, Simon Wood wrote:

> It has been reported that there is a new version (different USB rev)
> of the Logitech DFGT in the 'wild'.
> 
> This patch allows the kernel to recognise this wheel and send it the
> command to enter native mode.
> 
> Reported-by: "Denis Jovic" <djovic78@gmail.com>
> Signed-off-by: Simon Wood <simon@mungewell.org>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
