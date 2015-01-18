Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578AbbARTMk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 14:12:40 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:43858 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbbARTMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 14:12:38 -0500
Date: Sun, 18 Jan 2015 11:12:36 -0800
From: Darren Hart <dvhart@infradead.org>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: platform-driver-x86@vger.kernel.org,
        Corentin Chary <corentin.chary@gmail.com>,
        acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asus-laptop: is_visible should not return a bool
Message-ID: <20150118191236.GI56582@vmdeb7>
References: <1421418559-2058-1-git-send-email-vivien.didelot@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421418559-2058-1-git-send-email-vivien.didelot@savoirfairelinux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 09:29:19AM -0500, Vivien Didelot wrote:
> With a Lucid platform, asus_sysfs_is_visible() returns a boolean for
> ls_switch and ls_level attributes. Fix that and also s/supported/ok/ and
> s/asus->handle/handle/ to avoid lines wider than 80 chars.

This is two patches, a cleanup and functional change. Since the cleanup has
nothing to do with the cleanup, please split these out.

"ok" is an atypical variable name. It looks as though "ret" would server just as
well and is far more consistent with typical usage.

-- 
Darren Hart
Intel Open Source Technology Center
