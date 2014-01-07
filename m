Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbaAGTEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 14:04:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58354 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaAGTEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 14:04:10 -0500
Date: Tue, 7 Jan 2014 11:04:38 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.12 000/144] 3.12.7-stable review
Message-ID: <20140107190438.GA2346@kroah.com>
References: <20140106223745.326293132@linuxfoundation.org>
 <20140107190230.GA25199@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140107190230.GA25199@kroah.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 11:02:30AM -0800, Greg Kroah-Hartman wrote:
> As there were lots of changes to the -rc1 release, I've now done a -rc2.
> 
> Changes were with the mm NUMA patches (lots more added and reordered to
> fix potential build issues), some ARM clock fixes added, and a SH patch.

Oops, no, the ARM clock fixes were for the 3.10.26-rc1 release, not
3.12.7-rc1, sorry abou that.

Too many trees...

greg k-h
