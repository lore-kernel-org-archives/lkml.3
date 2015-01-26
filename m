Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbbAZVY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 16:24:29 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:46844 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756878AbbAZVYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 16:24:25 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1501241046550.7435-100000@netrider.rowland.org>
References: <1422057688-18956-1-git-send-email-jwerner@chromium.org>
	<Pine.LNX.4.44L0.1501241046550.7435-100000@netrider.rowland.org>
Date: Mon, 26 Jan 2015 13:24:24 -0800
X-Google-Sender-Auth: aUIhIcicNvBREYGnlc8mfU9rj4I
Message-ID: <CAODwPW-EeNn_rWLTen2MHnpB_skL08j1aGX06Acf8kph=i_pcg@mail.gmail.com>
Subject: Re: [PATCH] usb: Retry port status check on resume to work around RH bugs
From: Julius Werner <jwerner@chromium.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Julius Werner <jwerner@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Douglas Anderson <dianders@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>, Wu Liang feng <wulf@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You should use a sleeping function call, not a delay.

Whoops... yes, of course. Guess too much firmware work made me forget
what multithreading is there for a moment. Will send a v2.
