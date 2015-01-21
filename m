Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbbAUWXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 17:23:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37978 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbbAUWXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 17:23:09 -0500
Date: Wed, 21 Jan 2015 14:23:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        uobergfe@redhat.com
Subject: Re: [PATCH 0/9] watchdog: internally split softlockup and
 hardlockup
Message-Id: <20150121142308.5c88fc5a6ea51a70e64d3c9c@linux-foundation.org>
In-Reply-To: <20150121141552.GB116159@redhat.com>
References: <1415118024-194247-1-git-send-email-dzickus@redhat.com>
	<20150121141552.GB116159@redhat.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015 09:15:52 -0500 Don Zickus <dzickus@redhat.com> wrote:

> On Tue, Nov 04, 2014 at 11:20:15AM -0500, Don Zickus wrote:
> > The hardlockup and softockup had always been tied together.  Due to the request
> > of KVM folks, they had a need to have one enabled but not the other.
> > Internally rework the code to split things apart more cleanly.
> > 
> > There is a bunch of churn here, but the end result should be code that should
> > be easier to maintain and fix without knowing the internals of what is going
> > on.
> > 
> > Tested by Uli and myself.
> 
> Hi Andrew,
> 
> Poking again.  What can I do to move this along?  Should I repost?

I don't actually remember seeing this, but November was soooo long ago ;)

Yes please - refresh, retest, resend.  Don't forget to gather up any
new acked/reviewed/tested-by's.

