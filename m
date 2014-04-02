Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030449AbaDBV3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 17:29:05 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:64594 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030420AbaDBV3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 17:29:01 -0400
MIME-Version: 1.0
In-Reply-To: <20140228205358.GA5340@xanatos>
References: <1392959535-29654-1-git-send-email-jwerner@chromium.org>
	<20140228205358.GA5340@xanatos>
Date: Wed, 2 Apr 2014 14:29:00 -0700
X-Google-Sender-Auth: q6L1h0QVmxdKwzFMVbe-dJJPHak
Message-ID: <CAODwPW9ziqrT2THof7D6Y6_AVbk9Mvo9YteLJp7-KstAKoSzSA@mail.gmail.com>
Subject: Re: [PATCH] usb: xhci: Prefer endpoint context dequeue pointer over stopped_trb
From: Julius Werner <jwerner@chromium.org>
To: "Nyman, Mathias" <mathias.nyman@intel.com>
Cc: Julius Werner <jwerner@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathias,

> The patch looks fine.  Mathias is taking over for xHCI driver
> maintainership in 3.15.  He's currently handling queuing bug fix patches
> for 3.14 while I finish queueing feature patches for 3.15.  Mathias,
> will you test and queue this up for 3.14?

Did you pick this patch up anywhere yet or are there still issues with
it? I just want to make sure it doesn't slip through the cracks.
(Maybe I just didn't see it yet... are you still queueing patches in
sarah/xhci.git or do you have your own repository somewhere?)
