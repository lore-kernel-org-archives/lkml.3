Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbaBIKyu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 05:54:50 -0500
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:58490 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751258AbaBIKyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 05:54:47 -0500
Message-ID: <1391943284.5084.5.camel@x220>
Subject: Re: Linux 3.12.10
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Slaby <jslaby@suse.cz>
Cc: tomas.winkler@intel.com, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        alexander.usyskin@intel.com
Date: Sun, 09 Feb 2014 11:54:44 +0100
In-Reply-To: <52F75923.7080400@suse.cz>
References: <20140206200036.GA2121@kroah.com> <52F75923.7080400@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 10:54:45.0642 (UTC) FILETIME=[58203EA0:01CF2585]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-09 at 11:32 +0100, Jiri Slaby wrote:
> I'm getting this now:
> drivers/misc/mei/hbm.c: In function 'mei_hbm_dispatch':
> drivers/misc/mei/hbm.c:596:3: warning: 'return' with a value, in
> function returning void

Greg already queued my trivial patch to fix this for the v3.13.y branch.
(See commit 126be2c995203e82ebaeb39d3b41f742e98046e9 in
stable-queue.git).

I didn't realize this warning also appeared in the v3.12.y branch (which
I do not track). I guess that an identical patch can also be applied to
the v3.12.y branch.


Paul Bolle

