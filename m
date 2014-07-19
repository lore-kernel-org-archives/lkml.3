Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbaGSOvk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 10:51:40 -0400
Received: from netrider.rowland.org ([192.131.102.5]:55717 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754409AbaGSOvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 10:51:38 -0400
Date: Sat, 19 Jul 2014 10:51:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Dmitry Torokhov <dtor@google.com>
cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Patrik Fimml <patrikf@chromium.org>,
        Bastien Nocera <hadess@hadess.net>, <linux-pm@vger.kernel.org>,
        Benson Leung <bleung@google.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: Power-managing devices that are not of interest at some point
 in time
In-Reply-To: <1451627.FURGiR949u@dtor-glaptop>
Message-ID: <Pine.LNX.4.44L0.1407191039160.25162-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2014, Dmitry Torokhov wrote:

> > The area where it must interact with power management is wakeup, both remote
> > wakeup at run time and wakeup from system suspend.  In particular, there's
> > the question whether or not a device ignoring its input should be regarded
> > as a wakeup source.
> 
> I'd say no.

This raises an interesting question.  Suppose the system gets suspended 
while the lid is closed.  At that point, shouldn't wakeup devices be 
enabled, even if they were already inhibited?

Alan Stern

