Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760189Ab3CZT31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 15:29:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505Ab3CZT30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 15:29:26 -0400
Date: Tue, 26 Mar 2013 15:28:52 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@surriel.com>, torvalds@linux-foundation.org,
        davidlohr.bueso@hp.com, linux-kernel@vger.kernel.org,
        hhuang@redhat.com, jason.low2@hp.com, walken@google.com,
        lwoodman@redhat.com, chegu_vinod@hp.com,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: ipc,sem: sysv semaphore scalability
Message-ID: <20130326192852.GA25899@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@surriel.com>, torvalds@linux-foundation.org,
	davidlohr.bueso@hp.com, linux-kernel@vger.kernel.org,
	hhuang@redhat.com, jason.low2@hp.com, walken@google.com,
	lwoodman@redhat.com, chegu_vinod@hp.com,
	Peter Hurley <peter@hurleysoftware.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
 <20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 02:10:58PM -0700, Andrew Morton wrote:

 > Whichever way we go, we should get a wiggle on - this has been hanging
 > around for too long.  Dave, do you have time to determine whether
 > reverting 88b9e456b1649722673ff ("ipc: don't allocate a copy larger
 > than max") fixes things up?

Ok, with that reverted it's been grinding away for a few hours without incident.
Normally I see the oops within a minute or so.

	Dave
