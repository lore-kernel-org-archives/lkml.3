Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350AbaD2RRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 13:17:38 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:49096 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758331AbaD2RRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 13:17:36 -0400
MIME-Version: 1.0
In-Reply-To: <535FDE71.7000601@linux.intel.com>
References: <CAODwPW9i-pwgzE-OELwwkw2M_Vnhtsq4p=_5ppO7R6xXpzu==w@mail.gmail.com>
	<Pine.LNX.4.44L0.1404011753420.8643-100000@netrider.rowland.org>
	<CAODwPW_N9sNKCcfD9ebGgCW71+zN_Ge9OM9uq7eRwyxgfyu4Uw@mail.gmail.com>
	<535FDE71.7000601@linux.intel.com>
Date: Tue, 29 Apr 2014 10:17:35 -0700
X-Google-Sender-Auth: 8_EoN-T8iQfJFU4luS9dmSyaFkQ
Message-ID: <CAODwPW_wpG3Xupfgfzi4LeYukL6qOFNkK=Zg9Ks7sjRA5y450A@mail.gmail.com>
Subject: Re: [PATCH] usb: xhci: Correct last context entry calculation for
 Configure Endpoint
From: Julius Werner <jwerner@chromium.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Julius Werner <jwerner@chromium.org>,
        Alan Stern <stern@rowland.harvard.edu>,
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

Okay, thanks, sounds good. I personally don't care that much about the
stable backport. Let me respin this with a fixed commit message and
the type change Felipe suggested.
