Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab3E0WmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 18:42:14 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:60510 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab3E0WmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 18:42:12 -0400
Date: Tue, 28 May 2013 00:41:49 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: atomlin@redhat.com
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pshelar@nicira.com, mst@redhat.com, alexander.h.duyck@intel.com,
        riel@redhat.com, aquini@redhat.com, sergei.shtylyov@cogentembedded.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v2] skbuff: Hide GFP_ATOMIC page allocation failures for
 dropped packets
Message-ID: <20130527224149.GA4384@electric-eye.fr.zoreil.com>
References: <1369601101-23057-1-git-send-email-atomlin@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369601101-23057-1-git-send-email-atomlin@redhat.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

atomlin@redhat.com <atomlin@redhat.com> :
[...]
> Failed GFP_ATOMIC allocations by the network stack result in dropped
> packets, which will be received on a subsequent retransmit, and an
> unnecessary, noisy warning with a kernel backtrace.
> 
> These warnings are harmless, but they still cause users to panic and
> file bug reports over dropped packets. It would be better to hide the
> failed allocation warnings and backtraces, and let retransmits handle
> dropped packets quietly.

Linux VM may be perfect but device drivers do stupid things.

Please don't paper over it just because some shit ends in your backyard.

-- 
Ueimor
