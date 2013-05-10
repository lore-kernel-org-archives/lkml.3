Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab3EJKF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 06:05:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab3EJKFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 06:05:24 -0400
Date: Fri, 10 May 2013 11:05:21 +0100
From: Joe Thornber <thornber@redhat.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] dm-cache not writing out cache metadata at reboot?
Message-ID: <20130510100520.GD20880@debian>
Mail-Followup-To: device-mapper development <dm-devel@redhat.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-kernel@vger.kernel.org
References: <20130508214845.GA7729@blackbox.djwong.org>
 <20130508220526.GA24132@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130508220526.GA24132@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 06:05:26PM -0400, Mike Snitzer wrote:
> I'll defer to Joe on this but I think sync_metadata() is pretty heavy to
> be doing every 'dmsetup info'.  BTW, with just dm_cache_commit() the
> superblock fields aren't stale; only the on-disk hints are.

Agreed, the hints are v. expensive to write.

