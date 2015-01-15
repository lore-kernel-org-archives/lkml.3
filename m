Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbbAOHv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 02:51:56 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:40959 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbbAOHvz (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Thu, 15 Jan 2015 02:51:55 -0500
Message-ID: <1421308290.17403.4.camel@stgolabs.net>
Subject: Re: [PATCH] sound/oss: use current->state helpers
From: Davidlohr Bueso <dave@stgolabs.net>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andrew Veliath <andrewtv@usa.net>, Jaroslav Kysela <perex@perex.cz>,
        linux-kernel@vger.kernel.org
Date: Wed, 14 Jan 2015 23:51:30 -0800
In-Reply-To: <s5hzj9kzeex.wl-tiwai@suse.de>
References: <1421305903.17403.0.camel@stgolabs.net>
	 <s5hzj9kzeex.wl-tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-15 at 08:33 +0100, Takashi Iwai wrote:
> At Wed, 14 Jan 2015 23:11:43 -0800,
> Davidlohr Bueso wrote:
> > 
> > From: Davidlohr Bueso <dave@stgolabs.net>
> > 
> > Call __set_current_state() instead of assigning the new state directly.
> > These interfaces also aid CONFIG_DEBUG_ATOMIC_SLEEP environments, keeping
> > track of who changed the state.
> > 
> > Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
> 
> The author and sign-off have different addresses.  Could you align?

I don't see a problem with that. All my patches are the same.

Thanks,
Davidlohr

