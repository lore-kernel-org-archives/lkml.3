Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaCYCWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 22:22:22 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:42616 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbaCYCWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 22:22:19 -0400
Date: Tue, 25 Mar 2014 11:22:17 +0900
From: Akira Hayakawa <hayakawa@valinux.co.jp>
To: device-mapper development <dm-devel@redhat.com>
Cc: Matias Bjorling <m@bjorling.me>, Christoph Hellwig <hch@infradead.org>,
        snitzer@redhat.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, agk@redhat.com
Subject: Re: [dm-devel] [PATCH RFC v1 01/01] dm-lightnvm: An open FTL for
 open firmware SSDs
Message-Id: <20140325112217.a3d34601d745ace3fbc07c0f@valinux.co.jp>
In-Reply-To: <532C67D0.4020501@bjorling.me>
References: <1395383538-18019-1-git-send-email-m@bjorling.me>
	<1395383538-18019-2-git-send-email-m@bjorling.me>
	<20140321153749.GA17155@infradead.org>
	<532C67D0.4020501@bjorling.me>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Matias,

Sorry for jumping in. I am interested in this new feature, too.

> > Does it even make sense to expose the underlying devices as block
> > devices?  It surely would help to send this together with a driver
> > that you plan to use it on top of.
> > 
> 
> Agree, an underlying driver is missing. My first plan is to get a draft
> firmware for the OpenSSD to be stable and expose its primitives
> (read/write/erase) up through the ATA/SCSI stack. Communicating using
> vendor specific codes.

Exposing FTL to the host layer has potential to share mapping in cache software (or driver) and the device.
The "Unified Address Space" in the slides below addresses the problem of two levels of indirection.
http://www1.unine.ch/eurosys2012/posters/saxena.pdf

Developing API to share mapping between driver and the device sounds interesting, too.

--
Akira
