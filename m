Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbaKDNBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:01:05 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:40599 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbaKDNBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:01:00 -0500
Message-ID: <1415106058.11912.9.camel@umadbro>
Subject: Re: [PATCH] cfg80211: Move join/leave_ocb comments to be in the
 correct order
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        fengguang.wu@intel.com,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Tue, 04 Nov 2014 14:00:58 +0100
In-Reply-To: <1415105716.2064.17.camel@sipsolutions.net>
References: <1415105352-4295-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20141104_134918_159065_C641379A) <1415105716.2064.17.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-04 at 13:55 +0100, Johannes Berg wrote:
> On Tue, 2014-11-04 at 13:49 +0100, Rostislav Lisovy wrote:
> > Use the same ordering in the comments section as it
> > is in the structure below.
> 
> Well, I think I confused you :-)
> The report from Fengguang's build bot was actually when there was no
> documentation, and then I added it and I guess you thought that it was
> sending out the report because it was in the wrong place?
> 
> Anyway, I think I'll just leave it as is, and not apply this, ok?

Yes, that is what I thought. The second confusion was that most of the
other comments were not in the same order as their fields.

Ok, no need to apply this.

Rostislav

