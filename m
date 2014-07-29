Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbaG2JKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:10:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39677 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbaG2JKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:10:09 -0400
Date: Tue, 29 Jul 2014 11:10:02 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Benjamin_Tissoires_=A0?= 
	<benjamin.tissoires@redhat.com>
cc: Andrew Duggan <aduggan@synaptics.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: rmi: change logging level of log messages related
 to unexpected reports
In-Reply-To: <20140715190723.GC21045@mail.corp.redhat.com>
Message-ID: <alpine.LNX.2.00.1407291109380.16390@pobox.suse.cz>
References: <1405114551-24354-1-git-send-email-aduggan@synaptics.com> <1405114551-24354-2-git-send-email-aduggan@synaptics.com> <20140715190723.GC21045@mail.corp.redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2014, Benjamin Tissoires   wrote:

> On Jul 11 2014 or thereabouts, Andrew Duggan wrote:
> > Userspace tools may use hidraw to perform operations on the device from userspace while
> > hid-rmi is bound to the device. This can cause hid-rmi to print error messages when its
> > ->raw_event() callback gets called as the reports pass through the HID stack. In this case
> > receiving responses which were not initiated by hid-rmi is not actually an error so the resulting
> > error messages are incorrect and misleading. This patch changes the log messages to debug so
> > that the messages can be turned on in the event that there is a problem and there is not
> > a userspace tool running.
> > 
> > Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
> > ---
> 
> Fair enough
> 
> Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

[ sorry for late response, I am just re-appearing from vacation-land ]

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
