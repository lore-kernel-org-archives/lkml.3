Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbaDXUPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 16:15:33 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:62195 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbaDXUP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 16:15:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140424194905.GA12809@kroah.com>
References: <1398169382-12097-1-git-send-email-mathias.nyman@linux.intel.com>
	<1398169382-12097-2-git-send-email-mathias.nyman@linux.intel.com>
	<20140424194905.GA12809@kroah.com>
Date: Thu, 24 Apr 2014 13:15:26 -0700
X-Google-Sender-Auth: B-Ap6IVKnr99RLXgzPUIGYtAdNc
Message-ID: <CAODwPW8ryZsOAq_cNVYazxo2jjoQKZwsnGHEJ9kreMc10C9=Zg@mail.gmail.com>
Subject: Re: [PATCH 1/5] usb: xhci: Prefer endpoint context dequeue pointer
 over stopped_trb
From: Julius Werner <jwerner@chromium.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Julius Werner <jwerner@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You don't actually add the stable@ tag here, why not?
>
> You have read Documentation/stable_kernel_rules.txt for how stable
> kernel trees work, so why not add the label here?

Sorry... I actually didn't know about that file, I just added the
"should be backported" line because I have seen that in other commits.
I will adhere to those rules in the future.

The patch is a little over the line limit (150+ lines with context,
although most of it are scattered single-line changes). The issue it
solves is that a USB device may silently stop working until it is
disconnected, not sure if that's enough to qualify as "oh, that's not
good". I'll let you decide whether it still should be queued up for
stable backports or not.
