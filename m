Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbaCOVMM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 17:12:12 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:36503 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190AbaCOVML convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 17:12:11 -0400
X-Originating-IP: 2.13.152.53
From: =?iso-8859-1?Q?F=E9lix?= <xcodexif@xif.fr>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Subject: Re : [PATCH 1/1] remove cpqarray from mainline kernel
Date: Sat, 15 Mar 2014 22:12:06 +0100
Message-Id: <531DBFA6-87F9-437B-866F-1EC129E3A185@xif.fr>
To: Mike Miller <mike.miller@hp.com>, linux-kernel@vger.kernel.org,
        axboe@kernel.dk
Mime-Version: 1.0 (Apple Message framework v1085)
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17 2013, Jens Axboe wrote:
> On Thu, Oct 17 2013, Andrew Morton wrote:
> > On Thu, 17 Oct 2013 12:52:26 -0500 Mike Miller <mike.miller@hp.com>
> wrote:
> >
> > > cpqarray hasn't been used in over 12 years. It's doubtful that
> > > anyone still uses the board. It's time the driver was removed from the
> mainline kernel.
> > > The only updates these days are minor and mostly done by people
> outside of HP.
> >
> > It's amazing the weird stuff people get up to.  Perhaps we should
> > disable it in config for a cycle or two, see if that flushes anyone out?
> 
> I think that would be prudent, you never know what people run...

Yes, I am still using a 16 years old Compaq server, and I need the 'cpqarray' module.
So please, don't delete it...

-- 
Félix Faisant

