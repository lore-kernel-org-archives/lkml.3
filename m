Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbaDGSc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 14:32:26 -0400
Received: from 200.180.216.87.static.jazztel.es ([87.216.180.200]:44168 "HELO
	mail.sysvalve.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754025AbaDGScX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 14:32:23 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Apr 2014 14:32:22 EDT
Date: Mon, 7 Apr 2014 20:25:40 +0200
From: =?iso-8859-1?Q?L=2E_Alberto_Gim=E9nez?= <agimenez@sysvalve.es>
To: Takashi Iwai <tiwai@suse.de>
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chris Bajumpaa <cbajumpa@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging/line6: Fix kzalloc coding style issue
Message-ID: <20140407182540.GB5182@sysvalve.es>
References: <1396822352-14555-1-git-send-email-agimenez@sysvalve.es>
 <s5hmwfxd69b.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <s5hmwfxd69b.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr Apr 2014 at 08:05:04AM +0200, Takashi Iwai said:
> At Mon,  7 Apr 2014 00:12:30 +0200,
> L. Alberto Giménez wrote:
> > 
> > Pass the actual variable to sizeof instead of a type definition.
> > 
> > Signed-off-by: L. Alberto Giménez <agimenez@sysvalve.es>
> 
> Acked-by: Takashi Iwai <tiwai@suse.de>
> 
> BTW, does anyone work on line6 stuff actively?
> It's been in staging forever, and it's difficult to promote to the
> standard ALSA driver unless testing with the real hardware by some
> motivated person...

I'm Not sure of that. I think that development has somewhat stalled. I
have line6 hardware that at the moment is not supported (HD500), and I
would like to take the shot. But the problem is that there are no specs,
and Line6 won't release any (I asked, several times, even offering to
accept some kind of stupid NDA). So I would need to reverse engineer
Windows drivers, and I don't have the knowledge to interpret captured
USB traffic, so I'm stuck as well.

I'll try to revive the line6-devel mailing list sending some traffic
captures and see if anyone can help or point me in the right direction.
I would like to see my HD500 running natively on Linux, and it's a nice
challenge to actually do some useful work for the kernel :)


Regards,
L. Alberto Giménez

P.S.: I sent this mail this morning from an alternative machine, and it
seems that the mail configuration was broken. Resending, sorry if you
received this message twice.
