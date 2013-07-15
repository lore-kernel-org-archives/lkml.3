Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab3GOM2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 08:28:20 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38856 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001Ab3GOM2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 08:28:19 -0400
Date: Mon, 15 Jul 2013 14:28:17 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Gustavo Padovan <gustavo@padovan.org>,
        Marcel Holtmann <marcel@holtmann.org>, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: pull request: bluetooth 2013-06-23
Message-ID: <20130715122816.GA8383@amd.pavel.ucw.cz>
References: <20130623021351.GA2327@joana>
 <20130625201217.GA13879@amd.pavel.ucw.cz>
 <E95EC814-F064-4AEB-AE13-79982D3BE5E8@holtmann.org>
 <20130625210039.GA28448@joana>
 <20130626115255.GA7940@amd.pavel.ucw.cz>
 <20130626124736.GA3337@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130626124736.GA3337@joana>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Wed 2013-06-26 13:47:36, Gustavo Padovan wrote:
> * Pavel Machek <pavel@ucw.cz> [2013-06-26 13:52:55 +0200]:
> 
> > On Tue 2013-06-25 22:00:39, Gustavo Padovan wrote:
> > > Hi Marcel,
> > > 
> > > * Marcel Holtmann <marcel@holtmann.org> [2013-06-25 13:49:19 -0700]:
> > > 
> > > > Hi Pavel,
> > > > 
> > > > >> Jaganath Kanakkassery (1):
> > > > >>      Bluetooth: Fix invalid length check in l2cap_information_rsp()
> > > > > 
> > > > > Could we add the "3.10 vs. thinkpad x60" patch that fixes regression?
> > > > > It is from Johan Hedberg…
> > > > 
> > > > that one went into net-next tree. It is scheduled for 3.11 right now.
> > > > 
> > > > After 3.10 is out, maybe it can go into -stable, but otherwise I think it is bit late now. Unless someone wants to cherry-pick it.
> > > 
> > > That patch is actually in 3.10 already, it was included in the last pull
> > > request and John took it to wireless.git.
> > 
> > Is it? I tried pulling yesterday (some updates) and today (no
> > changes), am on:
> 
> Dave already pulled it so it should land in mainline anytime soon.

It seems to work in 3.10 and 3.11-rc1. Thanks!
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
