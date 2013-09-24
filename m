Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab3IXJsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:48:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42567 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809Ab3IXJsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:48:52 -0400
Date: Tue, 24 Sep 2013 11:48:48 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Few cleanups
In-Reply-To: <1378930345-6670-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1309241147500.18703@pobox.suse.cz>
References: <1378930345-6670-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Sep 2013, Benjamin Tissoires wrote:

> Well, while debugging hid-lenovo-tpkbd, I also cleaned it up a little (so this
> goes on top of the CVE series):
> - use devres API
> - remove usb references (so that the regressions tests through uhid are working)
> 
> This has also been tested by https://bugzilla.redhat.com/show_bug.cgi?id=1003998
> 
> And I also had a patch for sony that I wanted to send, but I was waiting for a
> complete drop of usb, which I still did not managed to do.

It took me some time, as I wanted to think a little bit more about 
cleaning up 2/3, but didn't really come up with something that'd be 
substantially nicer.

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
