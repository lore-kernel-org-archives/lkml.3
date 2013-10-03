Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab3JCVpY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 17:45:24 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:55020 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327Ab3JCVpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 17:45:22 -0400
Date: Thu, 3 Oct 2013 14:45:25 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        Alasdair Kergon <agk@redhat.com>
Subject: Re: [PATCH 16/22] dm: Refactor for new bio cloning/splitting
Message-ID: <20131003214525.GA12183@kmo-pixel>
References: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
 <1375912471-5106-17-git-send-email-kmo@daterainc.com>
 <20130928045909.GA19745@redhat.com>
 <20131003031738.GA27418@kmo-pixel>
 <20131003032320.GA15322@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003032320.GA15322@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 11:23:21PM -0400, Mike Snitzer wrote:
> Great, thanks for finding this, I'll test and review the code further.

Cool - let me know if you find anything else (how thoroughly do you
think you've tested it so far?)
