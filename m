Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaAYKa5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 05:30:57 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:35616 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaAYKa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 05:30:56 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 25 Jan 2014 02:30:45 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chad Williamson <chad@dahc.us>, Al Viro <viro@zeniv.linux.org.uk>,
        =?utf-8?B?VMO8bGluIMSwemVy?= <tulinizer@gmail.com>,
        Michael Banken <michael.banken@mathe.stud.uni-erlangen.de>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] drivers: staging: Mark functions as static and remove
 unused function in bpctl_mod.c
Message-ID: <20140125103044.GA6945@leaf>
References: <20140123224400.GA8124@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123224400.GA8124@rashika>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 04:14:00AM +0530, Rashika Kheria wrote:
> Mark functions as static in bpctl_mod.c because they are not used
> outside this file. Remove unused function from bpctl_mod.c.
> 
[...]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>
