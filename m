Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab3BDMFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:05:46 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:60986 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab3BDMFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 07:05:44 -0500
Message-ID: <510FA409.2080201@ahsoftware.de>
Date: Mon, 04 Feb 2013 13:05:29 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Bernie Thompson <bernie@plugable.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/3 v2] fb: udlfb: fix hang at disconnect
References: <50F2A310.5010006@ahsoftware.de> <1359139768-32294-1-git-send-email-holler@ahsoftware.de> <1359139768-32294-2-git-send-email-holler@ahsoftware.de> <20130128162238.7fba92fe.akpm@linux-foundation.org> <51071E21.9030008@ahsoftware.de> <5107A5ED.7020009@ahsoftware.de> <5107AE4F.9000809@ahsoftware.de> <5107F014.4030704@ahsoftware.de> <5108329E.2050802@ahsoftware.de> <20130204011413.GA6413@kroah.com>
In-Reply-To: <20130204011413.GA6413@kroah.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 04.02.2013 02:14, schrieb Greg KH:

> So you are right in that your driver will wait for forever for a
> disconnect() to happen, as it will never be called.  I don't understand
> the problem that this is causing when it happens.  What's wrong with
> udlfb that having the cpu suddently reset as the powerdown happened
> without it knowing about it?

There is nothing wrong with that. I've just explained why a problem 
doesn't occur on shutdown but on disconnect (of the device).

Regards,

Alexander
