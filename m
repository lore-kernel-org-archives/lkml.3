Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab3A1PMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 10:12:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130Ab3A1PMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 10:12:53 -0500
Date: Mon, 28 Jan 2013 10:12:44 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: Lord Glauber Costa of Sealand <glommer@parallels.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH review 2/6] userns: Allow any uid or gid mappings that
 don't overlap.
Message-ID: <20130128151244.GV17632@redhat.com>
References: <87ehh8it9s.fsf@xmission.com>
 <87zjzwhegj.fsf@xmission.com>
 <20130128142816.GU17632@redhat.com>
 <51068E23.5040000@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51068E23.5040000@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 06:41:39PM +0400, Lord Glauber Costa of Sealand wrote:
> Hello Mr. Someone.
> 
> On 01/28/2013 06:28 PM, Aristeu Rozanski wrote:
> > On Fri, Jan 25, 2013 at 06:21:00PM -0800, Eric W. Biederman wrote:
> >> When I initially wrote the code for /proc/<pid>/uid_map.  I was lazy
> >> and avoided duplicate mappings by the simple expedient of ensuring the
> >> first number in a new extent was greater than any number in the
> >> previous extent.
> >>
> >> Unfortunately that precludes a number of valid mappings, and someone
> >> noticed and complained.  So use a simple check to ensure that ranges
> >> in the mapping extents don't overlap.
> > 
> > Acked-by: Someone <aris@redhat.com>
> > 
> 
> Documentation/SubmittingPatches:
> 
> "then you just add a line saying
> 
>         Signed-off-by: Random J Developer <random@developer.example.org>
> 
> using your real name (sorry, no pseudonyms or anonymous contributions.)"
> 
> I know how it feels, but that is how it goes. You'll have to change that.

oh well, another trip to the social security office and DMV.

-- 
Aristeu

