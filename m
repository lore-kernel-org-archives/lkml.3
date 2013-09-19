Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab3ISPc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 11:32:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751Ab3ISPcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 11:32:25 -0400
Date: Thu, 19 Sep 2013 12:32:11 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Borislav Petkov <bp@suse.de>
Cc: Vinson Lee <vlee@freedesktop.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Vinson Lee <vlee@twitter.com>
Subject: Re: [PATCH] tools lib lk: Uninclude linux/magic.h in debugfs.c.
Message-ID: <20130919153211.GI3891@infradead.org>
References: <1379546200-17028-1-git-send-email-vlee@freedesktop.org>
 <20130919071720.GA9435@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130919071720.GA9435@pd.tnic>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 19, 2013 at 09:17:20AM +0200, Borislav Petkov escreveu:
> On Wed, Sep 18, 2013 at 04:16:40PM -0700, Vinson Lee wrote:
> > From: Vinson Lee <vlee@twitter.com>
> > 
> > The compilation only looks for linux/magic.h from the default include
> > 
> > Signed-off-by: Vinson Lee <vlee@twitter.com>
> > Cc: stable@vger.kernel.org # 3.10+
> 
> Acked-by: Borislav Petkov <bp@suse.de>

Thanks, applied.

- Arnaldo
