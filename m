Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbaFFS7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 14:59:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbaFFS7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 14:59:21 -0400
Date: Fri, 6 Jun 2014 11:59:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: jwboyer@fedoraproject.org, Sasha Levin <sasha.levin@oracle.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@intel.com>
Subject: Re: pte_present check on hugetlb_entry fix for 3.15?
Message-Id: <20140606115919.df17197c7182a0f7ed59c3a9@linux-foundation.org>
In-Reply-To: <53920c95.685a8c0a.2111.ffffe52fSMTPIN_ADDED_BROKEN@mx.google.com>
References: <20140606173546.GA1869@zod>
	<53920c95.685a8c0a.2111.ffffe52fSMTPIN_ADDED_BROKEN@mx.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  6 Jun 2014 14:46:37 -0400 Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> On Fri, Jun 06, 2014 at 01:36:54PM -0400, Josh Boyer wrote:
> > Hi Naoya,
> > 
> > I noticed that your
> > mm-add-pte_present-check-on-existing-hugetlb_entry-callbacks.patch in
> > Andrew's -mm tree has been queued for a while and has a CC to stable on
> > it.  Is that something that should get into 3.15?
> 
> I'm not sure. I guess Andrew will decide this in a few days.

I was planning on doing so but then Dave popped up with an alternative
which rather blew a hole in things.

