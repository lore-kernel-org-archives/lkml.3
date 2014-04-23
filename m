Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585AbaDWP5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:57:51 -0400
Received: from imap.devoid-pointer.net ([31.31.77.140]:49649 "EHLO
	smtp.devoid-pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932363AbaDWP5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:57:25 -0400
From: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@devoid-pointer.net>
To: simon@mungewell.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, oneukum@suse.de,
        linux-kernel@vger.kernel.org, jkosina@suse.cz, elias.vds@gmail.com,
        anssi.hannula@iki.fi, linux-input@vger.kernel.org
Subject: Re: [PATCH v2 09/24] input: Port hid-dr to ff-memless-next
Date: Wed, 23 Apr 2014 17:57:20 +0200
Message-ID: <8632820.WT3uD8DXZi@sigyn>
User-Agent: KMail/4.13 (Linux/3.14.1-1-my-rd; KDE/4.13.0; x86_64; ; )
In-Reply-To: <0792885b3347c5935a0af7a7a3f3bc70.squirrel@mungewell.org>
References: <1398175209-9565-1-git-send-email-madcatxster@devoid-pointer.net> <20140423154201.GA10531@core.coreip.homeip.net> <0792885b3347c5935a0af7a7a3f3bc70.squirrel@mungewell.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 of April 2014 11:47:05 simon@mungewell.org wrote:
> > On Wed, Apr 23, 2014 at 03:14:44PM +0000, madcatxster@devoid-pointer.net
> > 
> > wrote:
> >> This is another case where even the old code was flawed, right? Should
> >> I try to stuff the fixes into these patches or would a few extra
> >> patches addressing these problems be an easier to review solution? I
> >> can append such patches to the MLNX patchset.
> > 
> > Changes addressing pre-existing problem should go into separate patches
> > (preferably applicable first).
> 
> As a by-stander who would like to see MLNX move forward, should it be
> heldback by pre-existing problems in drivers that the MLNX dev(s) don't
> have hardware to test against...?
> 
> Simon.

Either approach is fine be me - I can rebase the MLNX patchset against the fixes 
and submit it again. I suppose that this is a good opportunity to fix a bunch 
old issues that would pass unnoticed otherwise. I would however appreciate as 
much comments regarding MLNX itself before I begin cleaning the ancient dust.

Thanks for your input,
Michal
