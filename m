Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbaFSPtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:49:15 -0400
Received: from sam.nabble.com ([216.139.236.26]:46912 "EHLO sam.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757982AbaFSPtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:49:13 -0400
Date: Thu, 19 Jun 2014 08:49:12 -0700 (PDT)
From: tdjames <tdjames@umd.edu>
To: linux-kernel@vger.kernel.org
Message-ID: <1403192952555-885031.post@n7.nabble.com>
In-Reply-To: <20140619153555.GA1740@fancy-poultry.org>
References: <1403190681610-885003.post@n7.nabble.com> <20140619153555.GA1740@fancy-poultry.org>
Subject: Re: How to disable Lazy Preempt in the kernel
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I use 
echo NO_PREEMPT_LAZY >/sys/kernel/debug/sched_features
(as root), I get the following error:

bash: echo: write error: Invalid argument

How do I get past this?  Thanks





--
View this message in context: http://linux-kernel.2935.n7.nabble.com/How-to-disable-Lazy-Preempt-in-the-kernel-tp885003p885031.html
Sent from the Linux Kernel mailing list archive at Nabble.com.
