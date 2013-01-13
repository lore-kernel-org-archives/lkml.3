Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab3AMQ4M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 11:56:12 -0500
Received: from netrider.rowland.org ([192.131.102.5]:43611 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755090Ab3AMQ4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 11:56:10 -0500
Date: Sun, 13 Jan 2013 11:56:09 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Alex Riesen <raa.lkml@gmail.com>
cc: Jens Axboe <axboe@kernel.dk>, <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: USB device cannot be reconnected and khubd "blocked for more
 than 120 seconds"
In-Reply-To: <CALxABCaE3=XpGmgNJs1pre11aJ8T0pntVzf_mA6_OYNzis9nvQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1301131153520.17578-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jan 2013, Alex Riesen wrote:

> On Sat, Jan 12, 2013 at 11:52 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Sat, 12 Jan 2013, Alex Riesen wrote:
> >> Now, who would be interested to handle this kind of misconfiguration ...
> >
> > So the whole thing was a false alarm?
> 
> Yes, almost. What about khubd hanging when machine is shutdown?

What about it?  I have trouble understanding all the descriptions you
have provided so far, because you talk about several different things
and change your mind a lot.  Can you provide a single, simple scenario
that illustrates this problem?

Alan Stern

