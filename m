Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab3EISNG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 14:13:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab3EISNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 14:13:04 -0400
Date: Thu, 9 May 2013 14:12:54 -0400
From: Dave Jones <davej@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: Dave Hansen <dave@sr71.net>, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, tj@kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/7] Put "Kernel hacking" Kconfig menu on a diet
Message-ID: <20130509181254.GA20844@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Kent Overstreet <koverstreet@google.com>,
	Dave Hansen <dave@sr71.net>, mmarek@suse.cz,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	tj@kernel.org, akpm@linux-foundation.org
References: <20130507204642.D010DDC1@viggo.jf.intel.com>
 <20130509173130.GA17021@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130509173130.GA17021@moria.home.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 10:31:30AM -0700, Kent Overstreet wrote:

 > > Let's try to introduce some sanity.  This set takes that 120 lines
 > > down to 55 and makes it vastly easier to find some things.  It's a
 > > start.
 > > 
 > Any chance this could go in sooner than later? I spend way too much time
 > hunting down options in kernel hacking and I spend enough time in that
 > menu that I should have the damn thing memorized by now.

+1. I was concerned that Dave had dropped this since the first time
it got posted a few months ago.  That stuff is long overdue a cleanup.


	Dave

