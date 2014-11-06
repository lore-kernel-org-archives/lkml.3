Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196AbaKFVtF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 16:49:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbaKFVtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 16:49:01 -0500
Date: Thu, 6 Nov 2014 16:48:19 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH] lib/halfmd4: make build optional
Message-ID: <20141106214818.GJ26472@redhat.com>
References: <1415309253-13019-1-git-send-email-aris@redhat.com>
 <1415309523.21965.2.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415309523.21965.2.camel@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 01:32:03PM -0800, Joe Perches wrote:
> why not default n ? (and in the other patch)

As I see, stuff in lib/ can be available by default unless you
specifically ask to disable it. It doesn't really matter in these
patches since most of the time the options will be selected indirectly
anyway.

-- 
Aristeu

