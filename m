Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933916Ab3GPThT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:37:19 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:29733 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932991Ab3GPThR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:37:17 -0400
Date: Tue, 16 Jul 2013 21:37:15 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jim Baxter <jim_baxter@mentor.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] kbuild: Build samples directory with make modules
Message-ID: <20130716193714.GA19924@merkur.ravnborg.org>
References: <jim_baxter@mentor.com> <1373999390-14548-1-git-send-email-jim_baxter@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373999390-14548-1-git-send-email-jim_baxter@mentor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 07:29:50PM +0100, Jim Baxter wrote:
> If CONFIG_SAMPLES is enabled with any of the sample
> modules enabled, they are only built if the make command
> includes uImage and modules (i.e. make uImage modules).

With the current location samples are built when you build vmlinux.
And vmlinux is implicit when you just type "make".

With the suggestion you have samples are built when you do "make modules".
IMO this is less logical than to built them with vmlinux as we do today.

	Sam

