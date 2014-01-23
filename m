Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbaAWACJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 19:02:09 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:47224 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbaAWACI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 19:02:08 -0500
Message-ID: <1390435246.587.18.camel@localhost>
Subject: Re: [BUG] at drivers/md/raid5.c:291! kernel 3.13-rc8
From: Ian Kumlien <ian.kumlien@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Date: Thu, 23 Jan 2014 01:00:46 +0100
In-Reply-To: <20140122115208.6a2b3909@notabene.brown>
References: <1390168823.587.1.camel@localhost>
	 <20140120113851.3b476ed8@notabene.brown> <1390178957.587.9.camel@localhost>
	 <20140120143748.33bb52d2@notabene.brown>
	 <1390242438.587.16.camel@localhost>
	 <20140122115208.6a2b3909@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On ons, 2014-01-22 at 11:52 +1100, NeilBrown wrote:
> On Mon, 20 Jan 2014 19:27:18 +0100 Ian Kumlien <ian.kumlien@gmail.com> wrote:
> > I have been unable to trip this up, so this was it!
> > 
> > Tested-by: Ian Kumlien <ian.kumlien@gmail.com>
> > 
> > I hope this hits stable ASAP ;)
> 
> I've push it out into my for-next branch.
> I'll probably send a pull request to Linus tomorrow.
> It has some chance of getting into a -stable branch next week (though I'm not
> really sure of the schedule).

Good, I bet I'm not the only one that will hit this...

> Thanks again for testing and reporting!

No problem, and thank you! ;)

> NeilBrown


