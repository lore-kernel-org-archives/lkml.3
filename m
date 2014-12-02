Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbaLBKkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 05:40:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60373 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbaLBKj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 05:39:57 -0500
Date: Tue, 2 Dec 2014 11:40:09 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jason Gerecke <killertofu@gmail.com>, Ping Cheng <pinglinux@gmail.com>,
        Hans Spath <inbox-546@hans-spath.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] HID: wacom: re-add accidentally dropped Lenovo PID
In-Reply-To: <1417452760-2763-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1412021138470.2524@pobox.suse.cz>
References: <1417452760-2763-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have now applied both to for-3.18/upstream-fixes, but I am not sure 
whether there will be any pull request before 3.18 release. But -stable 
markers are there, so it will then eventually be fixed in first -stable.

Thanks,

-- 
Jiri Kosina
SUSE Labs
