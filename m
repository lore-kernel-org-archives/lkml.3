Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbaATIjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 03:39:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50544 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaATIjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 03:39:18 -0500
Date: Mon, 20 Jan 2014 09:38:59 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Young <dyoung@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH] x86, perf_p4:  block PMIs on init to prevent a stream of
 unkown NMIs
Message-ID: <20140120083859.GD30183@twins.programming.kicks-ass.net>
References: <1389973301-134448-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389973301-134448-1-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 10:41:41AM -0500, Don Zickus wrote:
> I could have removed the ENABLE bit too, but was worried it would impact
> BIOS vendors secret ability to monitor cpu states.  I figured the ability to
> generate a PMI or not is not interesting to them and chose that route instead.


You worry about the wrong things, just clear the things.
