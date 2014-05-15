Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbaEOGmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 02:42:31 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:61222 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaEOGm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 02:42:29 -0400
Date: Thu, 15 May 2014 21:41:39 +0300
From: rtm <wwctrsrx@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: staging: line6: Add blank lines after
 declarations
Message-ID: <20140515184139.GA28806@gmail.com>
References: <1400025402-6265-1-git-send-email-wwctrsrx@gmail.com>
 <20140513120201.GA32045@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140513120201.GA32045@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 02:02:01PM +0200, Greg KH wrote:
> On Wed, May 14, 2014 at 02:56:42AM +0300, Artem Fetishev wrote:
> > Use the more common kernel coding style.
> > 
> > Signed-off-by: Artem Fetishev <wwctrsrx@gmail.com>
> > ---
> >  drivers/staging/line6/capture.c  |    4 ++++
> >  drivers/staging/line6/midi.c     |    2 ++
> >  drivers/staging/line6/playback.c |    5 +++++
> >  drivers/staging/line6/pod.c      |    5 +++++
> >  drivers/staging/line6/toneport.c |    2 ++
> >  drivers/staging/line6/variax.c   |    2 ++
> >  6 files changed, 20 insertions(+)
> > 
> > diff --git a/drivers/staging/line6/capture.c b/drivers/staging/line6/capture.c
> > index 0eda51d..14ed0d7 100644
> > --- a/drivers/staging/line6/capture.c
> > +++ b/drivers/staging/line6/capture.c
> > @@ -97,6 +97,7 @@ void line6_unlink_audio_in_urbs(struct snd_line6_pcm *line6pcm)
> >  		if (test_bit(i, &line6pcm->active_urb_in)) {
> >  			if (!test_and_set_bit(i, &line6pcm->unlink_urb_in)) {
> >  				struct urb *u = line6pcm->urb_audio_in[i];
> > +
> >  				usb_unlink_urb(u);
> >  			}
> >  		}
> > @@ -122,6 +123,7 @@ void line6_wait_clear_audio_in_urbs(struct snd_line6_pcm *line6pcm)
> >  		if (!alive)
> >  			break;
> >  		set_current_state(TASK_UNINTERRUPTIBLE);
> > +
> >  		schedule_timeout(1);
> >  	} while (--timeout > 0);
> >  	if (alive)
> 
> That line doesn't look like it needs to be added, why do so?
> 

I've removed that new line in v2 of the patch. I sent it two days ago.
