Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab3J0D2P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 23:28:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36271 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab3J0D2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 23:28:14 -0400
Date: Sat, 26 Oct 2013 20:30:00 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Krzysztof Mazur <krzysiek@podlesie.net>
Cc: linux-kernel@vger.kernel.org, Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH] DYNAMIC_DEBUG: use select DEBUG_FS instead of depends on
Message-ID: <20131027033000.GB32210@kroah.com>
References: <1382821093-2484-1-git-send-email-krzysiek@podlesie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382821093-2484-1-git-send-email-krzysiek@podlesie.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 26, 2013 at 10:58:13PM +0200, Krzysztof Mazur wrote:
> Depending on options that are configured later makes them hard
> to enable unless the user knows that he must go backwards.

Really?  We've had this for well over 2 years, people are confused about
this?

Where?

