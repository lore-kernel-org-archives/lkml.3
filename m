Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbbANOQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:16:10 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:52179 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbbANOQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:16:08 -0500
Date: Wed, 14 Jan 2015 15:16:03 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [PATCH 6/8] locking/mcs: Better differentiate between mcs
 variants
Message-ID: <20150114141603.GB12084@gmail.com>
References: <1419757883-4423-1-git-send-email-dave@stgolabs.net>
 <1419757883-4423-7-git-send-email-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419757883-4423-7-git-send-email-dave@stgolabs.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Correction, the build failure is probably due to the next patch 
in the series:

  locking: Use [READ,ASSIGN]_ONCE() for non-scalar types

If the reorganization patch tests out OK then I'll keep it in a 
monolithic form.

Thanks,

	Ingo

