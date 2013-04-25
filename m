Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800Ab3DYPHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 11:07:49 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60503 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758356Ab3DYPHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 11:07:47 -0400
Date: Thu, 25 Apr 2013 11:07:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Julius Werner <jwerner@chromium.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, Vincent Palatin <vpalatin@chromium.org>,
        Sameer Nanda <snanda@chromium.org>
Subject: Re: [PATCH v2] usb: ehci: Only sleep for post-resume handover if
 devices use persist
In-Reply-To: <CAODwPW-=g9fckOU7q468MoyXT=ib=hagNr2SSxY71hjBqRjCoQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1304251107090.1185-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Apr 2013, Julius Werner wrote:

> >> +extern int usb_for_each_dev(void *data, int (*fn)(struct usb_device *, void *));
> >
> > Line is too long.
> 
> The limit is 80 (inclusive), right? Without the diff's leading '+' I
> count exactly that...

Oh, okay, sorry.  I was fooled by the email client.

Alan Stern

