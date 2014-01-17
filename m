Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaAQRL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 12:11:58 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:39961 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbaAQRLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 12:11:55 -0500
Date: Fri, 17 Jan 2014 21:11:52 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Young <dyoung@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] x86, perf_p4:  block PMIs on init to prevent a stream of
 unkown NMIs
Message-ID: <20140117171152.GN1916@moon>
References: <1389973301-134448-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389973301-134448-1-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 10:41:41AM -0500, Don Zickus wrote:
> I tested this on a P4 we have in our lab.  After two or three crashes, I could
> normally reproduce the problem.  Now after 10 crashes, everything continues
> to boot correctly.
> 
> Cc: Dave Young <dyoung@redhat.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Don Zickus <dzickus@redhat.com>

Looks good to me, thanks a lot Don!

Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
