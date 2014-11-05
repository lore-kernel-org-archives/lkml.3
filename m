Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbaKEBpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 20:45:00 -0500
Received: from mail-qg0-f43.google.com ([209.85.192.43]:42968 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbaKEBo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 20:44:59 -0500
MIME-Version: 1.0
In-Reply-To: <20141103230913.GA11259@kroah.com>
References: <1414984077-9750-1-git-send-email-chris@rorvick.com>
	<20141103230913.GA11259@kroah.com>
Date: Tue, 4 Nov 2014 19:44:58 -0600
X-Google-Sender-Auth: M_zIYehWsDudkhB6ZdFMry3w2mY
Message-ID: <CAEUsAPbXR0vHdZGEtMgWOaksodnFu=TB=OV84x9SuX_peT-0NQ@mail.gmail.com>
Subject: Re: [RFC RESEND 00/10] Create separate header for ehci-dbgp driver
From: Chris Rorvick <chris@rorvick.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.de>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 5:09 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> It deletes lines of code overall, which looks good to me.  Feel free to
> resend without the "RFC" and I will queue it up.
>
> thanks,
>
> greg k-h

Done.

I went through the patches by hand to double check spelling based on
Daniele catching the s/notificaiton/notification/ typo but somehow
failed to make that fix to patch 02.  I can resend if you'd like, sorry
for the silly error.

Chris
