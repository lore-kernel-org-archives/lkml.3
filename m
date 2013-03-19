Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab3CSMoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 08:44:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46788 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab3CSMoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 08:44:22 -0400
Date: Tue, 19 Mar 2013 12:44:19 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [stable request] TTY: do not reset master's packet mode
Message-ID: <20130319124419.GA8398@hercules>
References: <5141AE1F.40308@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5141AE1F.40308@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 12:01:51PM +0100, Jiri Slaby wrote:
> Hi,
> 
> please include the patch below to all maintained stable trees.
> 
> commit b81273a132177edd806476b953f6afeb17b786d5
> Author: Jiri Slaby <jslaby@suse.cz>
> Date:   Tue Jan 15 23:26:22 2013 +0100
> 
>     TTY: do not reset master's packet mode

Queuing for 3.5.  Thanks

Cheers,
--
Luis
