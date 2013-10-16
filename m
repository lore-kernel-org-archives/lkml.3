Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759999Ab3JPAmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 20:42:37 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:51249 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759983Ab3JPAmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 20:42:35 -0400
MIME-Version: 1.0
In-Reply-To: <525DB456.1040006@cogentembedded.com>
References: <1381872227-24757-1-git-send-email-jwerner@chromium.org>
	<525DB456.1040006@cogentembedded.com>
Date: Tue, 15 Oct 2013 17:42:34 -0700
X-Google-Sender-Auth: Ttersre_zPn8x7Xeg1IvwYfrXuU
Message-ID: <CAODwPW-wKtN9JhoJCs+LoBx4Pj65+pozKv=ycLQJfsL1k28zEQ@mail.gmail.com>
Subject: Re: [PATCH] usb: hub: Clear Port Reset Change during init/resume
From: Julius Werner <jwerner@chromium.org>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Julius Werner <jwerner@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Benson Leung <bleung@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Duncan Laurie <dlaurie@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +               if ((portchange & USB_PORT_STAT_C_RESET)) {
>
>
>    Hm, why these double parens?

Oh... good question. I copied the entry below it, remove the && and
must have overlooked those. Sorry, v2 incoming...
