Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab3AXP2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 10:28:55 -0500
Received: from relay2.sgi.com ([192.48.179.30]:37033 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752380Ab3AXP2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 10:28:53 -0500
Date: Thu, 24 Jan 2013 09:28:51 -0600
From: Robin Holt <holt@sgi.com>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Robin Holt <holt@sgi.com>
Subject: How should I proceed to get commit 891348c to 3.0.y?
Message-ID: <20130124152851.GF3460@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I missed the email from 12/31 indicating commit 891348c was pulled from
the 3.0.y stable tree due to a build breakage.

That commit requires the enum defined in traps.h by commit c940826.  That,
in turn depends on commit 228bdaa95f which depends upon earlier commits.

How should I proceed?  Should I give you a patch that uses the constants
in xpc_main.c? Should I add a patch which just pulls the enum portion of
commit c940826 into traps.h? Any other direction you think this should go?

Thanks,
Robin
