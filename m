Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbaISL7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:59:21 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:57405 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbaISL7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:59:19 -0400
MIME-Version: 1.0
In-Reply-To: <20140919112709.GE4639@infradead.org>
References: <cover.1410983998.git.milosz@adfin.com>
	<e190ba39a6244ec19344f7fe161d6e4e89962a3d.1410983999.git.milosz@adfin.com>
	<20140919112709.GE4639@infradead.org>
Date: Fri, 19 Sep 2014 07:59:18 -0400
Message-ID: <CANP1eJFGf2vd3eJUuN2gzyvo4ZofEUusis0WodMYz3DY43G=5g@mail.gmail.com>
Subject: Re: [RFC v2 4/5] O_NONBLOCK flag for readv2/preadv2
From: Milosz Tanski <milosz@adfin.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 7:27 AM, Christoph Hellwig <hch@infradead.org> wrote:
> The subject needs an update now that the flag has been renamed.
>

You're right, I'm not sure how I missed it. Fixed it locally for the
next submission.

-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com
