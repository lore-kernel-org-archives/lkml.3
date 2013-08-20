Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab3HTUsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 16:48:47 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:44768 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab3HTUsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 16:48:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAODwPW--sX5P6-m82iEt4+w=o_u7mHfJZpMLgoTb8niXPi_M_Q@mail.gmail.com>
References: <1369445977-31404-1-git-send-email-jwerner@chromium.org>
	<20130529180652.GJ32085@xanatos>
	<CAODwPW--sX5P6-m82iEt4+w=o_u7mHfJZpMLgoTb8niXPi_M_Q@mail.gmail.com>
Date: Tue, 20 Aug 2013 13:48:44 -0700
X-Google-Sender-Auth: jVFqQ2FNs55bV-VbaNeQ5HwxovM
Message-ID: <CAODwPW_AXHsm7xw4zKM1yBO0aDJytCOnKeeWfw1NMaCAvst9JQ@mail.gmail.com>
Subject: Re: [PATCH] usb: xhci: Use non-interruptible sleep for XHCI commands
From: Julius Werner <jwerner@chromium.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?ISO-8859-1?Q?Frank_L=F6mker?= <Frank.Loemker@isa.de.com>,
        Julius Werner <jwerner@chromium.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vincent Palatin <vpalatin@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sarah,

I know you are probably swamped with patches, but this
(https://patchwork.kernel.org/patch/2612831/) has been hanging a few
months and I just wanted to double-check if it slipped through
somewhere. I still think this is necessary (regardless of any command
queue reengineering in the future) as explained in my last mail.
Please let me know if (and why) you disagree, and whether you have
intentionally decided to not pick this up.

Same goes (essentially) for:

usb: xhci: Fix Command Ring Stopped Event handling
(https://patchwork.kernel.org/patch/2612821/)
usb: xhci: Consolidate XHCI TD Size calculation
(https://patchwork.kernel.org/patch/2548321/)

Thanks!
