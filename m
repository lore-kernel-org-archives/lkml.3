Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab3AUN67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 08:58:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab3AUN65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 08:58:57 -0500
Date: Mon, 21 Jan 2013 13:58:21 +0000
From: thornber@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Amit Kale <akale@stec-inc.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        device-mapper development <dm-devel@redhat.com>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "lsf-pc@lists.linux-foundation.org" 
	<lsf-pc@lists.linux-foundation.org>,
        Joe Thornber <ejt@redhat.com>
Subject: Re: [LSF/MM TOPIC] Re: [dm-devel] Announcement: STEC EnhanceIO SSD
 caching software for Linux kernel
Message-ID: <20130121135821.GB4919@raspberrypi>
Mail-Followup-To: Mike Snitzer <snitzer@redhat.com>,
	Amit Kale <akale@stec-inc.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	device-mapper development <dm-devel@redhat.com>,
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
	"kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
	Joe Thornber <ejt@redhat.com>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D72F1@MYMBX.MY.STEC-INC.AD>
 <50F970A3.4000403@warr.net>
 <20130118161135.GA3118@raspberrypi>
 <50F97C0F.9010405@warr.net>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D7345@MYMBX.MY.STEC-INC.AD>
 <50F9963A.2080608@warr.net>
 <20130118212543.GB6425@blackbox.djwong.org>
 <20130118213759.GA30278@redhat.com>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B0A624D5D4D@MYMBX.MY.STEC-INC.AD>
 <20130121130951.GA16574@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130121130951.GA16574@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 08:09:51AM -0500, Mike Snitzer wrote:
> dm-cache is under active review for upstream inclusion.  I wouldn't
> categorize the chances of dm-cache going upstream when the v3.9 merge
> window opens as "very low".  But even if dm-cache does go upstream it
> doesn't preclude bcache and/or enhanceio from going upstream too.

As I understand it bcache is being reviewed too.
