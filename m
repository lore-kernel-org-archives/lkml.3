Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbaFBVkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 17:40:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbaFBVk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 17:40:27 -0400
Date: Mon, 2 Jun 2014 17:40:19 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.15-rc8 ... and merge window for 3.16
Message-ID: <20140602214019.GA2134@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CA+55aFwSLmJ1kLO-zNm944Q-=oYYH2Lo0W14Dn0mbj91V5MNFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwSLmJ1kLO-zNm944Q-=oYYH2Lo0W14Dn0mbj91V5MNFA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2014 at 07:37:20PM -0700, Linus Torvalds wrote:
 > So let's try to see how well that works - the last weeks of the
 > release tends to be me just waiting around to make sure nothing bad is
 > happening, so doing this kind of overlapping development *should* work
 > fine. Maybe it works so well that we'll end up doing it in the future
 > even if there *isn't* some kind of scheduling conflict that makes me
 > want to start the merge window before I'm 100% comfortable doing the
 > release for the previous version.

one side-effect of this is that the git-commits-head list is now posting
the commits you're queueing in your next branch but no way afaict to
distinguish them from changes going into 3.15

Can whoever maintains that hook add an X-branch header or something to make
filtering them easier ?

	Dave

