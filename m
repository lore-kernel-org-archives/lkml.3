Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463AbaGaNoz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:44:55 -0400
Received: from [195.154.187.82] ([195.154.187.82]:54130 "EHLO ou.quest-ce.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbaGaNoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:44:54 -0400
Message-ID: <1406814260.23396.6.camel@localhost.localdomain>
From: Yann Droneaud <ydroneaud@opteya.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Nicholas Krause <xerofoify@gmail.com>,
        Adrian Remonda <adrianremonda@gmail.com>,
        Murilo Opsfelder Araujo <mopsfelder@gmail.com>,
        devel@driverdev.osuosl.org, waydi1@gmail.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        daniel@ffwll.ch, maarten.lankhorst@canonical.com,
        sumit.semwal@linaro.org, Yann Droneaud <ydroneaud@opteya.com>
Date: Thu, 31 Jul 2014 15:44:20 +0200
In-Reply-To: <20140731133059.GO4856@mwanda>
References: <1406587103-5784-1-git-send-email-mopsfelder@gmail.com>
	 <1406811619.4911.10.camel@localhost.localdomain>
	 <20140731133059.GO4856@mwanda>
Organization: OPTEYA
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 37.162.119.135
X-SA-Exim-Mail-From: ydroneaud@opteya.com
Subject: Re: [PATCH] Staging: android: sw_sync.c: fix missing blank line
 after declaration
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on ou.quest-ce.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le jeudi 31 juillet 2014 à 16:30 +0300, Dan Carpenter a écrit :
> On Thu, Jul 31, 2014 at 03:00:19PM +0200, Yann Droneaud wrote:
> > Le lundi 28 juillet 2014 à 19:38 -0300, Murilo Opsfelder Araujo a
> > écrit :
> > > Fix coding style issue.
> > > 
> > > Signed-off-by: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
> > 
> > Is this some kind of game ?
> > 
> > The *same* patch was sent three times from three different email
> > addresses:
> 
> This is just normal.
> 
> Once I saw 7 people send the same patch.  I was almost the third person
> to send a fix last week.  I had the patch prepared to send, but I
> happened to look at my inbox before sending.
> 

As the initial patch was sent by someone who has some trouble with the
way things are done here [1], it raise some, probably false, alarms.

[1] "Help with flame wars"
http://lists.kernelnewbies.org/pipermail/kernelnewbies/2014-July/011394.html

Regards.

-- 
Yann Droneaud
OPTEYA


