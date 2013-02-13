Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934534Ab3BMRSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:18:23 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:52944 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934187Ab3BMRSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:18:22 -0500
Date: Wed, 13 Feb 2013 09:18:17 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: sjenning@linux.vnet.ibm.com, Konrad Wilk <konrad.wilk@oracle.com>,
        minchan@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        devel@linuxdriverproject.org, ngupta@vflare.org
Subject: Re: [PATCH] staging/zcache: Fix/improve zcache writeback code, tie
 to a config option
Message-ID: <20130213171817.GA14694@kroah.com>
References: <1360175261-13287-1-git-send-email-dan.magenheimer@oracle.com>
 <20130206190924.GB32275@kroah.com>
 <761b5c6e-df13-49ff-b322-97a737def114@default>
 <20130206214316.GA21148@kroah.com>
 <abbc2f75-2982-470c-a3ca-675933d112c3@default>
 <20130207000338.GB18984@kroah.com>
 <7393d8c5-fb02-4087-93d1-0f999fb3cafd@default>
 <20130211214944.GA22090@kroah.com>
 <694a9284-7d41-48c6-a55b-634fb2912f43@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <694a9284-7d41-48c6-a55b-634fb2912f43@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 08:55:29AM -0800, Dan Magenheimer wrote:
> For completeness, I thought I should add some planning items
> that ARE new functionality.  In my opinion, these can wait
> until after promotion, but mm developers may have different
> opinions:
> 
> ZCACHE FUTURE NEW FUNCTIONALITY
> 
> A. Support zsmalloc as an alternative high-density allocator
> B. Support zero-filled pages more efficiently
> C. Possibly support three zbuds per pageframe when space allows

Care to send a patch adding all of this "TODO" information to the TODO
file in the kernel so that we don't have to go through all of this again
in 3 months when I forget why I'm now rejecting your patches again?  :)

thanks,

greg k-h
