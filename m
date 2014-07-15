Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760231AbaGOXtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:49:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45913 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760161AbaGOXtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:49:01 -0400
Date: Tue, 15 Jul 2014 16:53:34 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Malcolm Priestley <tvboxspy@gmail.com>, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org,
        Forest Bond <forest@alittletooquiet.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V4 4/6] staging: vt6556: Remove typedefs
Message-ID: <20140715235334.GD32651@kroah.com>
References: <1405365333-17170-1-git-send-email-peter.senna@gmail.com>
 <1405365333-17170-4-git-send-email-peter.senna@gmail.com>
 <20140715150609.GA18174@kroah.com>
 <CA+MoWDobyMvP_LW+FmW+xjE5SRjx7mEDybVLc+fF5XuUweuyEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+MoWDobyMvP_LW+FmW+xjE5SRjx7mEDybVLc+fF5XuUweuyEA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 10:05:54PM +0200, Peter Senna Tschudin wrote:
> On Tue, Jul 15, 2014 at 5:06 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Mon, Jul 14, 2014 at 09:15:31PM +0200, Peter Senna Tschudin wrote:
> >> This patch removes uneeded typedefs reported by chackpatch and removes
> >> one enum. The removed enum from card.h:
> >>
> >> typedef enum _CARD_PHY_TYPE {
> >>     PHY_TYPE_AUTO = 0,
> >>     PHY_TYPE_11B,
> >>     PHY_TYPE_11G,
> >>     PHY_TYPE_11A
> >> } CARD_PHY_TYPE, *PCARD_PHY_TYPE;
> >
> > Why did you remove this?
> Unlike the other two enums this patch change, this one is not in use.
> As checkpatch complained about the typedef and it is not currently in
> use, I removed it.

Then say that, we want to know _why_ you do something, not _what_ you
do, as it's obvious from the code as to _what_ happens.

thanks,

greg k-h
