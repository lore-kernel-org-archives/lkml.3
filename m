Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263Ab3BOVFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 16:05:42 -0500
Received: from longford.logfs.org ([213.229.74.203]:58460 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab3BOVFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 16:05:41 -0500
Date: Fri, 15 Feb 2013 14:42:23 -0500
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: "Patrick O'Grady" <patrick@baymotion.com>
Cc: Joern Engel <joern@lazybastard.org>, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phram: Allow the user to set the erase page size.
Message-ID: <20130215194223.GA22790@logfs.org>
References: <CAJ7m5OqYv_=JB9NhHsqBsa8YU0DFRoP7C+W10PY22wonAGJK=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ7m5OqYv_=JB9NhHsqBsa8YU0DFRoP7C+W10PY22wonAGJK=A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 February 2013 12:35:46 -0800, Patrick O'Grady wrote:
> 
> Permit the user to specify the erase page size as a parameter.
> This solves two problems:
> 
> - phram can access images made by mkfs.jffs2.  mkfs.jffs2 won't
> create images with erase sizes less than 8KiB; many architectures
> define PAGE_SIZE as 4KiB.
> 
> - Allows more effective use of small capacity devices.  JFFS2
> needs somewhere between 2 and 5 empty pages for garbage collection;
> and for an NVRAM part with only 32KiB of space, a smaller erase page
> allows much better utilization in applications where garbage collection
> is important.
> 
> Signed-off-by: Patrick O'Grady <patrick@baymotion.com>

I can't see any argument against this.

Reviewed-by: Joern Engel <joern@logfs.org>

Jörn

--
"[One] doesn't need to know [...] how to cause a headache in order
to take an aspirin."
-- Scott Culp, Manager of the Microsoft Security Response Center, 2001
