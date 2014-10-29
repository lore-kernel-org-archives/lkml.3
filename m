Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934628AbaJ2QwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:52:15 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:39887 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934001AbaJ2QwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:52:13 -0400
Date: Wed, 29 Oct 2014 09:52:05 -0700
From: Tristan Lelong <tristan.lelong@blunderer.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: waydi1@gmail.com, dan.carpenter@oracle.com, viro@zeniv.linux.org.uk,
        gerb.stralko@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: android: logger: Remove uneeded tabs in
 variable declaration
Message-ID: <20141029165205.GA6253@localhost.localdomain>
References: <1414562950-6555-1-git-send-email-tristan.lelong@blunderer.org>
 <20141029160812.GA18229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029160812.GA18229@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 12:08:12AM +0800, Greg KH wrote:
> On Tue, Oct 28, 2014 at 11:09:10PM -0700, Tristan Lelong wrote:
> > This patch removes tabs used to align variable names in declaration and assignation.
> > It replaces them with exactly one space.
> 
> Why?  This seems like a totally unneeded change, sorry.

I thought that was a coding style issue, because of the "c-lineup-arglist-tabs-only" emacs function described in CodingStyle.
I guess I should have read the emacs documentation before assuming that both were linked.

I am sorry for the mistake.
