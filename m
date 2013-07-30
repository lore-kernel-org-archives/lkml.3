Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab3G3ROr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 13:14:47 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:42635 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab3G3RO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 13:14:27 -0400
MIME-Version: 1.0
In-Reply-To: <1375204090-27465-1-git-send-email-jwerner@chromium.org>
References: <1375204090-27465-1-git-send-email-jwerner@chromium.org>
Date: Tue, 30 Jul 2013 10:14:26 -0700
X-Google-Sender-Auth: tr0mJlB25PeBeUZvJzGXGPL7-6k
Message-ID: <CAODwPW9_8xBZVGGMit2uRz8RV7HgDOU659zwhObkMu8bnF_uNQ@mail.gmail.com>
Subject: Re: [PATCH] usb: core: don't try to reset_device() a port that got
 just disconnected
From: Julius Werner <jwerner@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Julius Werner <jwerner@chromium.org>,
        linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Benson Leung <bleung@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-andiry.xu... he wrote that section originally but it seems that his
address is no longer available.
