Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563Ab3IYBkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:40:46 -0400
Received: from tartarus.angband.pl ([89.206.35.136]:44918 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab3IYBkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:40:43 -0400
Date: Wed, 25 Sep 2013 03:40:42 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Copy on write hard links?
Message-ID: <20130925014042.GA30393@angband.pl>
References: <0EF3994A-6BC7-4FC7-AD2D-B4BE087EBFCA@m3y3r.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0EF3994A-6BC7-4FC7-AD2D-B4BE087EBFCA@m3y3r.de>
X-Junkbait: adolf@angband.pl, zareba@angband.pl
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: kilobyte@tartarus.angband.pl
X-SA-Exim-Scanned: No (on tartarus.angband.pl); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 08:36:56PM +0200, Thomas Meyer wrote:
> Is there such a thing?

In mainline, AFAIK no.  The vserver patchset, on the other hand, adds a new
xattr, iunlink, that copies the whole file when needed.  That works on most
filesystems.

That's quite a hack, though, and I think you'd be better off using btrfs
which does cow transparently at a lower level than hardlinks.

-- 
ᛊᚨᚾᛁᛏᚣ᛫ᛁᛊ᛫ᚠᛟᚱ᛫ᚦᛖ᛫ᚹᛖᚨᚲ
