Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750864Ab3IGDWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 23:22:45 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:43055 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab3IGDWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 23:22:43 -0400
Date: Fri, 6 Sep 2013 20:22:40 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Herrmann <dh.herrmann@gmail.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Jiri Kosina <jkosina@suse.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>
Subject: Re: [GIT] HID for 3.12 merge window
Message-ID: <20130907032240.GA1256@core.coreip.homeip.net>
References: <alpine.LNX.2.00.1309061202050.26934@pobox.suse.cz>
 <20130906202022.GA353@x4>
 <CANq1E4Rf4c4zj1mD1aPr93Q2_M65DCEJhuLqcBWa5uH9tcKuWA@mail.gmail.com>
 <CA+55aFzg-dv-N7UjXx2pxUJ+QQOOy0qtp_e94PDSM=tVd=LgUw@mail.gmail.com>
 <506b9d43-f734-40f9-b137-0749a496fd6d@email.android.com>
 <CA+55aFzLy+-VF022ORuyWk-qQO7gDSQ1LZES1+bEUxz0QxrH-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzLy+-VF022ORuyWk-qQO7gDSQ1LZES1+bEUxz0QxrH-g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 06:00:29PM -0700, Linus Torvalds wrote:
> On Fri, Sep 6, 2013 at 5:58 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> >
> > The patch still had problems so I'd revert it and wii bits and try again later.
> 
> Ok. Mind giving me a list of commits, so that I don't have to do a
> trial-and-error thing? I know the primary commit that causes problems,
> but there are commits that seem to depend on it..


Sorry for the delay. I believe you need to revert:

73f8645 HID: wiimote: add support for Guitar-Hero drums
61e0065 Input: introduce BTN/ABS bits for drums and guitars

Hmm... there also was "HID: wiimote: add support for Guitar-Hero
guitars" but I do not see it...

Thanks.

-- 
Dmitry
