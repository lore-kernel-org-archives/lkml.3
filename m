Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbbAGON1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:13:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbbAGON0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:13:26 -0500
Date: Wed, 7 Jan 2015 09:13:21 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Subject: Re: [LKP] [sb_edac] 50d1bb93672: EDAC sbridge: ECC is disabled.
 Aborting
Message-ID: <20150107141320.GI25309@redhat.com>
References: <1418890406.26403.2.camel@intel.com>
 <20141218090536.0d671dca@recife.lan>
 <1418966819.26403.33.camel@intel.com>
 <20150105140606.GA25309@redhat.com>
 <1420616586.6201.74.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420616586.6201.74.camel@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 03:43:06PM +0800, Huang Ying wrote:
> Do not find memory modules' part number in EFI menu.  Some information
> about memory is:
> 
> 2133MT/s Micron DRx8 8GB UDIMM

Based on a quick search it doesn't look it's ECC memory :(
If/when you have a chance to open this box, could you look on the memory
modules' stickers?
Thanks!

-- 
Aristeu

