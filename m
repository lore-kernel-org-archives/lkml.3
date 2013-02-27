Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760801Ab3B0TTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 14:19:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755387Ab3B0TTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 14:19:52 -0500
Date: Wed, 27 Feb 2013 14:19:23 -0500
From: Dave Jones <davej@redhat.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "gnehzuil.liu" <gnehzuil.liu@gmail.com>,
        Zheng Liu <wenqing.lz@taobao.com>, Borislav Petkov <bp@alien8.de>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] ext4 updates for 3.9
Message-ID: <20130227191923.GA1121@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Theodore Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"gnehzuil.liu" <gnehzuil.liu@gmail.com>,
	Zheng Liu <wenqing.lz@taobao.com>, Borislav Petkov <bp@alien8.de>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20130227153435.GB5609@thunk.org>
 <20130227154450.GA23402@x4>
 <20130227170157.GA222@x4>
 <98C6DE45-F050-4AAD-82E2-7352F5BB0A5D@gmail.com>
 <20130227172256.GA236@x4>
 <7BFB2135-A1F0-4B6D-9962-16E75E5560F8@gmail.com>
 <20130227174553.GA224@x4>
 <CA+55aFwWA1jPEEQNx_5oJ6Ze=3yFb6=E9nraBfX-Ve=WjRkQMw@mail.gmail.com>
 <20130227184912.GA19624@thunk.org>
 <20130227185625.GA224@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130227185625.GA224@x4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 07:56:25PM +0100, Markus Trippelsdorf wrote:
 > On 2013.02.27 at 13:49 -0500, Theodore Ts'o wrote:
 > 
 > > Markus, Dave, can you confirm that this fixes your problem?
 > 
 > Yes, it fixes the issue.

Looks like it's fixed here too.

How did this make it through -next without anyone hitting it ?

I can't remember how many years ago I last bought a disk < 1TB,
and I can't be alone.  Or is everyone all about SSDs these days?

Is anyone running xfstests or similar on linux-next regularly ?

	Dave

