Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab3IYWaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 18:30:18 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:49249 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab3IYWaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 18:30:16 -0400
Message-ID: <524363AF.1040502@ahsoftware.de>
Date: Thu, 26 Sep 2013 00:29:03 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130712 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Anton Altaparmakov <aia21@cam.ac.uk>,
        STAGING SUBSYSTEM <devel@driverdev.osuosl.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Benjamin Valentin <benpicco@zedat.fu-berlin.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add exFAT driver
References: <20130830124622.5f81b7d4@rechenknecht2k7> <20130830154205.GA1411@kroah.com> <20130925183632.08a0d073@rechenknecht2k7> <20130925172704.GB5258@kroah.com> <20130925183235.GA9659@srcf.ucam.org> <20130925184539.GA4208@kroah.com> <52433978.9050302@ahsoftware.de> <20130925202151.GA6149@kroah.com> <57387214-F138-4471-996E-3FB1ED28346C@cam.ac.uk> <20130925221006.GB32312@kroah.com>
In-Reply-To: <20130925221006.GB32312@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.09.2013 00:10, schrieb Greg Kroah-Hartman:

> Please stick to technical discussions about the code on the kernel
> mailing lists.  Legal discussions can be left up to the lawyers, of
> which we are not.

Hmm, but I would like to know if someone has to fear getting owned by
Microsoft if he would use that driver.

Giving the rumours about Linux companies having to pay Microsoft and
giving the fact that all of those licencees seem to don't have to speak
about what Microsoft claims patents for and for what they have to pay, I
obviously think adding that driver to Linux and thus making exFAT more
general accepted is a very bad idea.

Of course, I'm not a lawyer too, but as a responsible Linux developer, I
should at least be able to warn other parities when they approach me and
want to use exFAT. Doing such without the maybe necessary license might
drive small companies into the ground because most of them are unable to
even think about having the money needed to talk with Microsoft lawyers
in front of a court.

Regards,

Alexander Holler

