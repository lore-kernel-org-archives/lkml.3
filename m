Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbaKVTEa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 14:04:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35170 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbaKVTE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 14:04:29 -0500
Date: Sat, 22 Nov 2014 11:03:06 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>, HPDD-discuss@ml01.01.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lustre: Coalesce string fragments
Message-ID: <20141122190306.GA663@kroah.com>
References: <1416527019.6651.25.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416527019.6651.25.camel@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 03:43:39PM -0800, Joe Perches wrote:
> Join the string fragments to make it easier to grep.
> 
> Ignored all the 80+ column lines.
> Added many missing spaces when coalescing formats.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> 
> I used this directory as a test for a new "coalesce string
> fragments" checkpatch rule.  Might as well submit the change.

Doesn't apply to my staging-testing branch anymore due to other changes
that were sent in before yours :(
