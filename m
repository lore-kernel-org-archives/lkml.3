Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760110AbaJ3Rfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 13:35:31 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:48945 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758498AbaJ3Rf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 13:35:29 -0400
Date: Thu, 30 Oct 2014 10:35:24 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Peter Hutterer <peter.hutterer@who-t.net>
Cc: Andrew Duggan <aduggan@synaptics.com>, Hans de Goede <hdegoede@redhat.com>,
        linux-input@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Christopher Heiny <cheiny@synaptics.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: synaptics - add support for ForcePads
Message-ID: <20141030173524.GC36444@dtor-ws>
References: <20140908165520.GA35051@core.coreip.homeip.net>
 <540EAFD1.2040307@redhat.com>
 <20140909170636.GA28774@core.coreip.homeip.net>
 <540F7A19.3070704@synaptics.com>
 <20140909225725.GA18901@core.coreip.homeip.net>
 <20141030003855.GA15677@jelly.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141030003855.GA15677@jelly.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 10:38:55AM +1000, Peter Hutterer wrote:
> On Tue, Sep 09, 2014 at 03:57:25PM -0700, Dmitry Torokhov wrote:
> > From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > 
> > ForcePads are found on HP EliteBook 1040 laptops. They lack any kind of
> > physical buttons, instead they generate primary button click when user
> > presses somewhat hard on the surface of the touchpad. Unfortunately they
> > also report primary button click whenever there are 2 or more contacts
> > on the pad, messing up all multi-finger gestures (2-finger scrolling,
> > multi-finger tapping, etc). To cope with this behavior we introduce a
> > delay (currently 50 msecs) in reporting primary press in case more
> > contacts appear.
> 
> can we assign INPUT_PROP_FORCEPAD to this? or PRESSUREPAD or something if
> we're worried about trademarks. This is something I'd like to know in
> userspace, we can then ignore clicks completely and do the rest ourselves. 

Hmm, I think we can, but I'd like to wait to see if there are more
models with such touchpads (I sure hope there isn't; lack of tactile
feedback on presses is not the best user experience so I hope this
initiative dies a quick death).

Thanks.

-- 
Dmitry
