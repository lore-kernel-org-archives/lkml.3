Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935718Ab3DKRaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 13:30:14 -0400
Received: from plane.gmane.org ([80.91.229.3]:36953 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765541Ab3DKRaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 13:30:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Lauri Kasanen <cand@gmx.com>
Subject: Re: [RFC] rootmpfs
Date: Thu, 11 Apr 2013 17:25:17 +0000 (UTC)
Message-ID: <loom.20130411T192058-26@post.gmane.org>
References: <1364992208.18069.18@driftwood>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 84.248.177.169 (Opera/9.64 (X11; Linux x86_64; U; fi) Presto/2.1.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley <rob <at> landley.net> writes:

> Attached is my quick and dirty hack to make rootfs be tmpfs when  
> CONFIG_TMPFS is
> enabled. It can't be this easy or somebody would have done it in the  
> _eight_years_
> since https://lkml.org/lkml/2006/7/31/145

Hi Rob,

We've been using a variation of the 2006 patch in TinyCore for years. It's 
a fairly essential piece for us, as using it can save several seconds of 
boot time for us.

Since we run in the initramfs, to get size limits and swappability, we used 
to tar the files and switch_root. Both unnecessary steps when the kernel 
could directly unpack to tmpfs.

So consider this a +1 "we use this".

- Lauri

