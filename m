Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab3FEKEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 06:04:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753952Ab3FEKEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 06:04:47 -0400
Date: Wed, 5 Jun 2013 12:04:39 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
X-X-Sender: lczerner@localhost.localdomain
To: "Theodore Ts'o" <tytso@mit.edu>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        akpm@linux-foundation.org, hughd@google.com
Subject: Re: [PATCH v4 20/20] ext4: Allow punch hole with bigalloc enabled
In-Reply-To: <20130531151454.GB19561@thunk.org>
Message-ID: <alpine.LFD.2.03.1306051203310.2912@redhat.com>
References: <1368549454-8930-1-git-send-email-lczerner@redhat.com> <1368549454-8930-21-git-send-email-lczerner@redhat.com> <20130531151454.GB19561@thunk.org>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 May 2013, Theodore Ts'o wrote:

> Date: Fri, 31 May 2013 11:14:54 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
>     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
>     akpm@linux-foundation.org, hughd@google.com
> Subject: Re: [PATCH v4 20/20] ext4: Allow punch hole with bigalloc enabled
> 
> On Tue, May 14, 2013 at 06:37:34PM +0200, Lukas Czerner wrote:
> > In commits 5f95d21fb6f2aaa52830e5b7fb405f6c71d3ab85 and
> > 30bc2ec9598a1b156ad75217f2e7d4560efdeeab we've reworked punch_hole
> > implementation and there is noting holding us back from using punch hole
> > on file system with bigalloc feature enabled.
> > 
> > This has been tested with fsx and xfstests.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > Reviewed-by: Jan Kara <jack@suse.cz>
> 
> This patch is causing a test failure with bigalloc enabled with the
> xfstests shared/298.
> 
> Since it's at the end of the invalidate page range tests, I'm going to
> drop this patch for now.  Could you take a look at this?

Hi Ted,

sorry for the delay, I've been on vacation last week so I am trying
to catch on the recent development :) I'll take a look at it
hopefully this week. Thanks for letting me know.

-Lukas

> 
> Thanks!!
> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
