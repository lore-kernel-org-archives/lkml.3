Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859AbaL2KO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 05:14:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34766 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbaL2KOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 05:14:24 -0500
Date: Mon, 29 Dec 2014 11:14:22 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-2?Q?Giedrius_Statkevi=E8ius?= 
	<giedrius.statkevicius@gmail.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] hid: Add a new id 0x501a for Genius MousePen i608X
In-Reply-To: <1419632910-12773-1-git-send-email-giedrius.statkevicius@gmail.com>
Message-ID: <alpine.LNX.2.00.1412291112460.1680@pobox.suse.cz>
References: <1419632910-12773-1-git-send-email-giedrius.statkevicius@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Dec 2014, Giedrius Statkevičius wrote:

> New Genius MousePen i608X devices have a new id 0x501a instead of the
> old 0x5011 so add a new #define with "_2" appended and change required
> places.
> 
> The remaining two checkpatch warnings about line length
> being over 80 characters are present in the original files too and this
> patch was made in the same style (no line break).
> 
> Just adding a new id and changing the required places should make the
> new device work without any issues according to the bug report in the
> following url.
> 
> This patch was made according to and fixes:
> https://bugzilla.kernel.org/show_bug.cgi?id=67111
> 
> Signed-off-by: Giedrius Statkevičius <giedrius.statkevicius@gmail.com>

Applied to for-3.19/upstream-fixes.

-- 
Jiri Kosina
SUSE Labs
