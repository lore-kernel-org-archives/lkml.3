Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760285AbaCUJGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 05:06:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbaCUJGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 05:06:39 -0400
Date: Fri, 21 Mar 2014 09:06:30 +0000
From: Joe Thornber <thornber@redhat.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: snitzer@redhat.com, agk@redhat.com, neilb@suse.de,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matias =?iso-8859-1?Q?Bj=F8rling?= <m@bjorling.me>
Subject: Re: [dm-devel] [PATCH RFC v1 00/01] dm-lightnvm introduction
Message-ID: <20140321090630.GA30044@debian>
Mail-Followup-To: device-mapper development <dm-devel@redhat.com>,
	snitzer@redhat.com, agk@redhat.com, neilb@suse.de,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Matias =?iso-8859-1?Q?Bj=F8rling?= <m@bjorling.me>
References: <1395383538-18019-1-git-send-email-m@bjorling.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1395383538-18019-1-git-send-email-m@bjorling.me>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matias,

This looks really interesting and I'd love to get involved.  Do you
have any recommendations for what hardware I should pick up?

- Joe


On Thu, Mar 20, 2014 at 11:32:17PM -0700, Matias Bjørling wrote:
> Hi,
> 
> Users that have custom firmware SSDs, may choose to expose their flash directly.
> This allows the host to control logical to physical address mappings, garbage
> collection strategy, wear-leveling, and so on.
