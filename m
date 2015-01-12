Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbbALWyC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 17:54:02 -0500
Received: from mail-yk0-f178.google.com ([209.85.160.178]:42474 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbbALWyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 17:54:00 -0500
From: Andrew Milkovich <amilkovich@gmail.com>
X-Google-Original-From: Andrew Milkovich <root@zenbook.hsd1.ca.comcast.net>
Date: Mon, 12 Jan 2015 14:53:53 -0800
To: Greg KH <gregkh@linuxfoundation.org>
Cc: benjamin.romer@unisys.com, david.kershner@unisys.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: unisys: virtpci: fixed coding style errors
Message-ID: <20150112225353.GA22382@zenbook.hsd1.ca.comcast.net>
References: <1418865910-21337-1-git-send-email-amilkovich@gmail.com>
 <20150110014123.GA30739@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150110014123.GA30739@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jan 09, 2015 at 05:41:23PM -0800, Greg KH wrote:
> On Wed, Dec 17, 2014 at 05:25:10PM -0800, Andrew Milkovich wrote:
> > Fixed coding style errors per checkpatch.pl. Inline comments removed.
> 
> What coding errors did you fix?  Please be specific.

Some inline comments were removed. Some talked about chanptr, which is known
because the first argument is the chan.

The other comments talked about no parent bus, but NULL signifies that there is
no parent bus.
