Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab3EUXY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 19:24:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139Ab3EUXY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 19:24:56 -0400
Date: Tue, 21 May 2013 19:24:48 -0400
From: Dave Jones <davej@redhat.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: [Intel-gfx] pipe_off wait timed out
Message-ID: <20130521232448.GA14347@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	intel-gfx <intel-gfx@lists.freedesktop.org>
References: <20130521230108.GB12713@redhat.com>
 <CAKMK7uFB2u1hO+fLk49vVsT_+A-MDbMDPhGDtPmcK+aUQMipZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uFB2u1hO+fLk49vVsT_+A-MDbMDPhGDtPmcK+aUQMipZw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 01:10:36AM +0200, Daniel Vetter wrote:
 > On Wed, May 22, 2013 at 1:01 AM, Dave Jones <davej@redhat.com> wrote:
 > > This is new to me as of 3.10-rc2.
 > 
 > If this is an ironlake with a DP output it's a know issue which seems
 > to pop up every once in a while.

00:02.0 VGA compatible controller: Intel Corporation Atom Processor D4xx/D5xx/N4xx/N5xx Integrated Graphics Controller (rev 02)

 > Otherwise we need to take a look
 > here. If so can you please boot with drm.debug=0xe, reproduce the
 > issue and attach the complete dmesg?
 > 
 > Also does 3.10-rc1 work (since you mention -rc2 specifically and there
 > wasn't really a lot going into that for drm/i915).

It had been running rc1 for the last week or so without incident.
Though I've been away, with the monitor turned off.

Judging by the trace, this seems to be related to console blanking ?
(this is my home firewall, so spends most of its time with the screen
 turned off)

I've added that debug option to my command line, I'll keep an eye on it
and try to reproduce over the next few days.

	Dave

