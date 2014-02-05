Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaBEPvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 10:51:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54050 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbaBEPvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 10:51:09 -0500
Date: Wed, 5 Feb 2014 16:51:05 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Patrick McHardy <kaber@trash.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: HID bluetooth regression
In-Reply-To: <20140202110324.GA4895@macbook.localnet>
Message-ID: <alpine.LNX.2.00.1402051650130.8614@pobox.suse.cz>
References: <20140202110324.GA4895@macbook.localnet>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Feb 2014, Patrick McHardy wrote:

> Commit b1a1442a2 (HID: core: fix reporting of raw events) introduced a
> regression that causes lockups for bluetooth trackpads.
> 
> This was already discussed in this thread in September:
> 
> http://www.kernelhub.org/?p=2&msg=329823
> 
> but it seems nothing has been fixed so far, I still get the lockups
> in 3.13. Reverting that patch fixes it for me, but it would be great
> if someone could push a proper fix upstream.
> 
> If you need me to test anything, please let me know.

Hi,

this is being discussed in

	https://www.mail-archive.com/linux-input@vger.kernel.org/msg07391.html

The plan is to push bandaid fix for -rc2 (see the last few messages in the 
thread) and proper fix for 3.15.

-- 
Jiri Kosina
SUSE Labs
