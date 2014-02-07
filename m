Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbaBGP5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 10:57:43 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:3806 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751831AbaBGP5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 10:57:42 -0500
Date: Fri, 7 Feb 2014 10:57:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ben Myers <bpm@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com
Subject: Re: [GIT PULL] XFS fix for 3.14-rc2
Message-ID: <20140207155740.GB6857@home.goodmis.org>
References: <20140206173158.6A2A14266DC@whiskey.americas.sgi.com>
 <CA+55aFzxUtHWL1hPcNv-zUXFWzrZtKAsh_ZVotfFUvH1hqDrMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzxUtHWL1hPcNv-zUXFWzrZtKAsh_ZVotfFUvH1hqDrMg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 01:34:53PM -0800, Linus Torvalds wrote:
> I have no idea why you keep re-sending this.
> 
> It got merged a week ago. See commit f1499382f114.
> 

Ben, you might want to subscribe to git-commits-head@vger.kernel.org
and then add this to your .procmailrc:

:0 H
* List-id: <git-commits-head.vger.kernel.org>
{
        :0 B
        * !Signed-off-by: Ben Myers <bpm@sgi.com>
        /dev/null

        :0 fw
        | /bin/sed -e 's/^Subject: /Subject: [linus-commit]/'
}


Then you get a nice email when your commits are added to Linus's tree.

-- Steve

