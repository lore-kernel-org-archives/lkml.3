Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab3FYVAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 17:00:46 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:46306 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab3FYVAo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 17:00:44 -0400
Date: Tue, 25 Jun 2013 22:00:39 +0100
From: Gustavo Padovan <gustavo@padovan.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Pavel Machek <pavel@ucw.cz>, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: pull request: bluetooth 2013-06-23
Message-ID: <20130625210039.GA28448@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Marcel Holtmann <marcel@holtmann.org>, Pavel Machek <pavel@ucw.cz>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Rafael J. Wysocki" <rjw@sisk.pl>
References: <20130623021351.GA2327@joana>
 <20130625201217.GA13879@amd.pavel.ucw.cz>
 <E95EC814-F064-4AEB-AE13-79982D3BE5E8@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <E95EC814-F064-4AEB-AE13-79982D3BE5E8@holtmann.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcel,

* Marcel Holtmann <marcel@holtmann.org> [2013-06-25 13:49:19 -0700]:

> Hi Pavel,
> 
> >> Jaganath Kanakkassery (1):
> >>      Bluetooth: Fix invalid length check in l2cap_information_rsp()
> > 
> > Could we add the "3.10 vs. thinkpad x60" patch that fixes regression?
> > It is from Johan Hedberg…
> 
> that one went into net-next tree. It is scheduled for 3.11 right now.
> 
> After 3.10 is out, maybe it can go into -stable, but otherwise I think it is bit late now. Unless someone wants to cherry-pick it.

That patch is actually in 3.10 already, it was included in the last pull
request and John took it to wireless.git.

	Gustavo
