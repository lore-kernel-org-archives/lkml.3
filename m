Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbaASVCd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 16:02:33 -0500
Received: from science.horizon.com ([71.41.210.146]:27821 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751956AbaASVCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 16:02:31 -0500
Date: 19 Jan 2014 16:02:28 -0500
Message-ID: <20140119210228.9598.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, nate@thatsmathematics.com
Subject: Re: math_state_restore and kernel_fpu_end disable interrupts?
Cc: adilger@dilger.ca, arjan@linux.intel.com, jack@suse.cz,
        linux-kernel@vger.kernel.org, maarten-baert@hotmail.com, mingo@elte.hu,
        suresh.b.siddha@intel.com, tglx@linutronix.de, viro@zeniv.linux.org.uk
In-Reply-To: <alpine.DEB.2.10.1401191150520.2663@minerva.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's credited to Suresh Siddha, whom I've cc'ed (along with others who 
> signed off).  Suresh, if you're still around, could you comment on why 
> math_state_restore always leaves interrupts disabled, regardless of their 
> state on entry?  Is there a deep reason or is it a bug?

What the comments seemed to be implying was that it was a bug to enter
this code with interrupts enabled.  So the problem may be a little bit
more systemic; expert counsel is required.

> George, does it help your problem?

I'm trying it now.  But it takes a while for me to reproduce, and even
longer to be sure the problem has gone away.  So anything you hear from
me within a week will be bad news.
