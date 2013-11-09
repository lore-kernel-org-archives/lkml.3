Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab3KIF1a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 00:27:30 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:45368 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab3KIF1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 00:27:25 -0500
Date: Fri, 8 Nov 2013 21:29:49 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>, Noam Camus <noamc@ezchip.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] Critical ARC Fix for 3.12
Message-ID: <20131109052949.GA14585@kroah.com>
References: <1383394669-20175-1-git-send-email-vgupta@synopsys.com>
 <CAMuHMdV-PXujh_vf_rwz7-bAi7wBaSL+9tWixvWnpWXr7skKZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdV-PXujh_vf_rwz7-bAi7wBaSL+9tWixvWnpWXr7skKZA@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 03, 2013 at 11:29:54AM +0100, Geert Uytterhoeven wrote:
> Added CC stable, so Greg will see it.
> Added commit 9c41f4eeb9d51f3ece20428d35a3ea32cf3b5622, so Greg knows
> what to cherry-pick.

It was already tagged with a cc: stable marking, so all is good.

thanks,

greg k-h
