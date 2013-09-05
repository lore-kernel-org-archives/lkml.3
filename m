Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761772Ab3IEAMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 20:12:13 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:46287 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab3IEAML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 20:12:11 -0400
Date: Wed, 4 Sep 2013 17:12:07 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: rebase of the h8300-remove tree
Message-ID: <20130905001207.GA16300@roeck-us.net>
References: <20130905095657.a3d9b1d461295bdd02efe0ec@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905095657.a3d9b1d461295bdd02efe0ec@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 09:56:57AM +1000, Stephen Rothwell wrote:
> Hi Guenter,
> 
> Why did you bother rebasing the h8300-remove tree?  None of the patches
> changed at all (not that that would matter).
> 
Just wanted it based on v3.11. But you are right, it was unnecessary.
Won't happen again.

Note that I don't plan to send it to Linus in this commit window.
I thought about it, but it seems to be a bit too hasty.

Guenter
