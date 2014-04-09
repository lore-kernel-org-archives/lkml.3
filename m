Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933332AbaDINfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 09:35:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932748AbaDINfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 09:35:01 -0400
Date: Wed, 9 Apr 2014 09:34:34 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Jason Baron <jbaron@akamai.com>, tony.luck@intel.com, hpa@zytor.com,
        mingo@kernel.org, dougthompson@xmission.com, m.chehab@samsung.com,
        mitake@dcl.info.waseda.ac.jp, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] ie31200_edac: Add driver
Message-ID: <20140409133433.GJ29214@redhat.com>
References: <cover.1396645124.git.jbaron@akamai.com>
 <760765424abe31811027ff3efd078bc858b7d3ed.1396645124.git.jbaron@akamai.com>
 <20140409113552.GJ6529@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409113552.GJ6529@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 01:35:52PM +0200, Borislav Petkov wrote:
> Btw, remind me again why this isn't part of the sb_edac? AFAICT, the
> e3-12xx thing is a Sandybridge, right?
> 
> Why not put it into sb_edac - it is small enough and if you're lucky,
> you might even share functionality?

By quickly looking at the driver (sorry Jason, no proper review yet :( )
it's a very different beast. Tony, any insights on why?

-- 
Aristeu

