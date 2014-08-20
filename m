Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbaHTOuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 10:50:05 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:50389 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbaHTOuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 10:50:02 -0400
Date: Wed, 20 Aug 2014 07:49:54 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andreas Mohr <andi@lisas.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 1/2] SOUND: kill gameport bits
Message-ID: <20140820144952.GB18099@core.coreip.homeip.net>
References: <20140820024638.GA25240@rhlx01.hs-esslingen.de>
 <20140820051815.GA1109@core.coreip.homeip.net>
 <s5hwqa3hetu.wl-tiwai@suse.de>
 <20140820063130.GA11226@core.coreip.homeip.net>
 <s5htx57hc89.wl-tiwai@suse.de>
 <s5hfvgrwe59.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hfvgrwe59.wl-tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 02:15:30PM +0200, Takashi Iwai wrote:
> At Wed, 20 Aug 2014 09:05:58 +0200,
> Takashi Iwai wrote:
> > Well, it worked on my test machine a year ago or so.  Maybe I had a
> > good luck.
> 
> FYI, now I tested again an analog joystick on SB Live put on a Dell
> IvyBridge desktop with 3.17-rc1 x86-64 kernel, and it worked fine as
> is.
> 
> So it's not that broken.

That's probably because in your system TSCs are stable when switching CPU
frequency. Earlier systems had bunch of issues there IIRC.

Thanks.

-- 
Dmitry
