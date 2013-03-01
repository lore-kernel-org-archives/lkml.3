Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610Ab3CARq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 12:46:26 -0500
Received: from longford.logfs.org ([213.229.74.203]:58592 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab3CARqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 12:46:25 -0500
Date: Fri, 1 Mar 2013 11:22:39 -0500
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 0/9] Add blockconsole version 1.1 (try 2)
Message-ID: <20130301162239.GC16393@logfs.org>
References: <1362087602-8979-1-git-send-email-joern@logfs.org>
 <s5htxovxcrl.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <s5htxovxcrl.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 March 2013 18:15:10 +0100, Takashi Iwai wrote:
> 
> I got a build error after pulling onto the latest Linus tree.  Also I
> have another couple of trivial fixes.  The patches will follow.

Awesome, thanks!  Please give me some time for caffeine and sunshine
to take effect before merging.  I want to s/bc_/bcon_/g one of the
patches, otherwise they look fine.

Jörn

--
Computer system analysis is like child-rearing; you can do grievous damage,
but you cannot ensure success."
-- Tom DeMarco
