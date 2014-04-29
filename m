Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbaD2DLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 23:11:30 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59486 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbaD2DL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 23:11:27 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1404011753420.8643-100000@netrider.rowland.org>
References: <CAODwPW9i-pwgzE-OELwwkw2M_Vnhtsq4p=_5ppO7R6xXpzu==w@mail.gmail.com>
	<Pine.LNX.4.44L0.1404011753420.8643-100000@netrider.rowland.org>
Date: Mon, 28 Apr 2014 20:11:27 -0700
X-Google-Sender-Auth: 2KFtfj4Y_jdeEMxeFK5xrNCMCEI
Message-ID: <CAODwPW_N9sNKCcfD9ebGgCW71+zN_Ge9OM9uq7eRwyxgfyu4Uw@mail.gmail.com>
Subject: Re: [PATCH] usb: xhci: Correct last context entry calculation for
 Configure Endpoint
From: Julius Werner <jwerner@chromium.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Julius Werner <jwerner@chromium.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>, Jim Lin <jilin@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*bump*

Sarah, Mathias, can we decide how to proceed with this? I think the
section Alan quoted is a pretty good argument in favor of my
interpretation (although of course this would not be the first time
that two sections of a spec contradict each other). But more
importantly, we have a case that just generates a clearly wrong Slot
Context right now (the one that only drops endpoints), and I see no
way how you could construct a correct Slot Context for that case with
Sarah's interpretation. We need to resolve that somehow.
