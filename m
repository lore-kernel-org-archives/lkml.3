Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab3LJECf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 23:02:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57049 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab3LJECc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 23:02:32 -0500
Date: Mon, 9 Dec 2013 20:04:08 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "Preetam D'Souza" <preetamjdsouza@gmail.com>
Cc: devel@driverdev.osuosl.org, Brian Swetland <swetland@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: android: fix parantheses coding style issue in
 alarm-dev.c
Message-ID: <20131210040408.GA15898@kroah.com>
References: <1386455752-17600-1-git-send-email-preetamjdsouza@gmail.com>
 <20131209013019.GA18048@kroah.com>
 <CABYqeiVRqoAZAH+9_=mn=5+fMPHtehTK7zyAagNwuuAHC_UtZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABYqeiVRqoAZAH+9_=mn=5+fMPHtehTK7zyAagNwuuAHC_UtZA@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top


On Mon, Dec 09, 2013 at 07:53:19PM -0800, Preetam D'Souza wrote:
> Hey Greg--I'm working against Linus' latest tree on
> https://github.com/torvalds/linux.git ... which tree should I be using
> for the updated code?

linux-next or the subsystem-specific tree (for drivers/staging/ that
would be the staging.git tree at git.kernel.org, and use the
staging-next branch.)

hope this helps,

greg k-h
