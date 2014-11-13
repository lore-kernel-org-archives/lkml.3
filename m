Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934527AbaKMWLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 17:11:18 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:47661 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933765AbaKMWLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 17:11:16 -0500
Date: Thu, 13 Nov 2014 17:11:15 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Benson Leung <bleung@chromium.org>
cc: johan@kernel.org, Jiri Kosina <jkosina@suse.cz>,
        <linux-usb@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sameer Nanda <snanda@chromium.org>
Subject: Re: [PATCH] HID: usbhid: get/put around clearing needs_remote_wakeup
In-Reply-To: <CANLzEktsBvmX7Nbn=+JBq6A=cowqnFVPJ1ymQjbv4dgrDvSLFA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1411131710200.4266-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2014, Benson Leung wrote:

> On Thu, Nov 13, 2014 at 1:18 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > If you interchange the two lines then the flag _will_ be cleared before
> > usb_kill_urb() and autosuspend_check() can run.  This means your patch
> > description is bogus.
> 
> Gotcha. v2 posted. Thanks for the direction.

Wait a minute -- in your previous email you said this approach didn't 
work.  So does it work or doesn't it?

Alan Stern

