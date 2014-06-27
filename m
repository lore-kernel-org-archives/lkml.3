Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbaF0CsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 22:48:05 -0400
Received: from imap.thunk.org ([74.207.234.97]:60424 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbaF0CsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 22:48:03 -0400
Date: Thu, 26 Jun 2014 22:48:01 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ext4: total breakdown on USB hdd, 3.0 kernel
Message-ID: <20140627024801.GG6826@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Pavel Machek <pavel@ucw.cz>,
	kernel list <linux-kernel@vger.kernel.org>
References: <20140626202021.GA8512@xo-6d-61-c0.localdomain>
 <20140626203052.GA9449@xo-6d-61-c0.localdomain>
 <20140626205049.GA11577@xo-6d-61-c0.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140626205049.GA11577@xo-6d-61-c0.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 10:50:49PM +0200, Pavel Machek wrote:
> 
> And for every bug in kernel, there's one in fsck: I did not expect it, but fsck actually
> suceeded, and marked fs as clean. But second fsck had issues with /lost+found...

I'd need the previous fsck transcript to have any idea what might have
happened.  I'll note though you are using an ancient version of e2fsck
(1.41.12, and there have been a huge number of bug fixes since
May 2010....)

						- Ted
