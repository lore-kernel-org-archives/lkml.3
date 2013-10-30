Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab3J3R2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 13:28:09 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:44987 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab3J3R2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 13:28:07 -0400
MIME-Version: 1.0
In-Reply-To: <20131027013402.GA7146@leaf>
References: <20131024122255.GI9378@mwanda>
	<20131024122512.GB9534@mwanda>
	<20131026181709.GB10488@kroah.com>
	<20131027013402.GA7146@leaf>
Date: Wed, 30 Oct 2013 10:28:06 -0700
Message-ID: <CA+8MBbK3dicmwOJb0mhTwr59O1tqzZgEGmMfSQV61Z=aK_64oA@mail.gmail.com>
Subject: Re: [PATCH] commit: Add -f, --fixes <commit> option to add Fixes: line
From: Tony Luck <tony.luck@gmail.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Git Mailing List <git@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, Greg KH <greg@kroah.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        ksummit-attendees@lists.linuxfoundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 26, 2013 at 6:34 PM, Josh Triplett <josh@joshtriplett.org> wrote:

> +               format_commit_message(commit, "Fixes: %h ('%s')\n", sb, &ctx);

What is the value of double wrapping the commit message inside '...'
and then ('...')?

-Tony
