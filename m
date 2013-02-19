Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab3BSMwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 07:52:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52884 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510Ab3BSMws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 07:52:48 -0500
Date: Tue, 19 Feb 2013 13:52:41 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Paul Sbarra <sbarra.paul@gmail.com>
Cc: simon@mungewell.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] hid: Add report descriptor for Logitech Driving
 Force wheel
In-Reply-To: <1361123594-2813-1-git-send-email-sbarra.paul@gmail.com>
Message-ID: <alpine.LNX.2.00.1302191351380.17024@pobox.suse.cz>
References: <1361123594-2813-1-git-send-email-sbarra.paul@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2013, Paul Sbarra wrote:

> This is the original report descriptor as reported by lsusb -vd 046d:c294.

I have now applied both patches.

Paul, please try to provide more verbose changelogs in the future even for 
such trivial changes as this.

Thanks.

-- 
Jiri Kosina
SUSE Labs
