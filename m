Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbaAGMwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:52:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58712 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbaAGMws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:52:48 -0500
Date: Tue, 7 Jan 2014 13:52:45 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Barry Song <21cnbao@gmail.com>
cc: arnd@arndb.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Bin Shi <Bin.Shi@csr.com>,
        Barry Song <Baohua.Song@csr.com>
Subject: Re: [PATCH] apm-emulation: add hibernation APM events to support
 suspend2disk
In-Reply-To: <1388729334-14242-1-git-send-email-21cnbao@gmail.com>
Message-ID: <alpine.LNX.2.00.1401071352170.4962@pobox.suse.cz>
References: <1388729334-14242-1-git-send-email-21cnbao@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jan 2014, Barry Song wrote:

> From: Bin Shi <Bin.Shi@csr.com>
> 
> Some embedded systems use hibernation for fast boot. and in it,
> some software components need to handle specific things before
> hibernation and after restore. So it needs to capture the apm
> status about these pm events.
> 
> Currently apm just supports suspend to ram, but not suspend to disk,
> so here add logic about hibernation apm events.
> 
> Signed-off-by: Bin Shi <Bin.Shi@csr.com>
> Signed-off-by: Barry Song <Baohua.Song@csr.com>

Ok, I am taking this. Thanks.

-- 
Jiri Kosina
SUSE Labs
