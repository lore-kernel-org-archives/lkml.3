Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab3KUXWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 18:22:47 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48844 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab3KUXWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 18:22:46 -0500
Date: Thu, 21 Nov 2013 23:22:42 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Michael Marineau <michael.marineau@coreos.com>,
        Waiman Long <Waiman.Long@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: 3.12 Regression: dcache: Translating dentry into pathname
 without taking rename_lock 232d2d60
Message-ID: <20131121232242.GJ10323@ZenIV.linux.org.uk>
References: <CAGr1u3vZU_Pxwu1nSab0PExNPQsE0xiSpcoMbUQ7MeGbJzBAjA@mail.gmail.com>
 <20131113123947.GB13318@ZenIV.linux.org.uk>
 <CAGr1u3spS2G8r7jCAnFZukE_zGkEGtsk0SSyTj3H39kK9E0_tQ@mail.gmail.com>
 <20131121230107.GA15179@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121230107.GA15179@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 03:01:07PM -0800, Greg KH wrote:

> Al, did this fix end up in Linus's tree yet?  I'd like to pull it into
> the next 3.12-stable release, but will wait until Linus has it of
> course.

Yes - ede4ce.
