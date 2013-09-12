Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab3ILTbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 15:31:20 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:49379 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752387Ab3ILTbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 15:31:19 -0400
Message-ID: <1379014276.11313.9.camel@x220.thuisdomein>
Subject: Re: [PATCH] mei: me: downgrade "suspend" message to debug level
From: Paul Bolle <pebolle@tiscali.nl>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 12 Sep 2013 21:31:16 +0200
In-Reply-To: <1379013442.11313.5.camel@x220.thuisdomein>
References: <1379013442.11313.5.camel@x220.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Sep 2013 19:31:17.0700 (UTC) FILETIME=[A6DE8040:01CEAFEE]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-12 at 21:17 +0200, Paul Bolle wrote:
> The mei_me driver prints "suspend" at error level at each suspend.
> Downgrade that uninteresting message to debug level.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Lightly tested (on top of v3.10.10, actually). Should apply cleanly to
> v3.11 or current master.
> 
> Perhaps a better fix is to remove this message entirely. 

Rechecking my logs I noticed a "stop" error on module unload. That
message could be downgraded to debug level too. But it could also be
removed. If Tomas could say what is preferable I'll send a second
version of this trivial patch.


Paul Bolle

