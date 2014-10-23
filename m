Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747AbaJWVIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 17:08:48 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:64442 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932129AbaJWVIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 17:08:46 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: balbi@ti.com
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-usb@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [resend PATCH 1/3] ACPI / platform: provide default DMA mask
Date: Thu, 23 Oct 2014 23:29:14 +0200
Message-ID: <1722133.hMugdLeoUT@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141023150605.GJ13573@saruman>
References: <1411545639-18741-1-git-send-email-heikki.krogerus@linux.intel.com> <2473176.cCrEmjuJQD@vostro.rjw.lan> <20141023150605.GJ13573@saruman>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 23, 2014 10:06:05 AM Felipe Balbi wrote:
> 
> --HSQ3hISbU3Um6hch
> Content-Type: text/plain; charset=us-ascii
> Content-Disposition: inline
> Content-Transfer-Encoding: quoted-printable
> 
> On Wed, Oct 22, 2014 at 04:19:45PM +0200, Rafael J. Wysocki wrote:
> > On Wednesday, October 22, 2014 10:33:08 AM Adrian Hunter wrote:
> > > On 21/10/14 16:13, Adrian Hunter wrote:
> > > > On 21/10/14 16:08, Rafael J. Wysocki wrote:
> > > >> On Tuesday, October 21, 2014 03:27:45 PM Adrian Hunter wrote:
> > > >>> On 24/09/14 16:49, Rafael J. Wysocki wrote:
> > > >>>> On Wednesday, September 24, 2014 11:00:37 AM Heikki Krogerus wrote:
> > > >>>>> Most devices are configured for 32-bit DMA addresses.
> > > >>>>> Setting the mask to 32-bit here removes the need for the
> > > >>>>> drivers to do it separately.
> > > >>>>>
> > > >>>>> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > > >>>>> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> > > >>>>
> > > >>>> ACK
> > > >>>
> > > >>> Hi
> > > >>>
> > > >>> I need this for another driver.  Did this patch go anywhere?
> > > >>
> > > >> It's not in 3.18-rc1 as far as I can say.
> > > >>
> > > >>> Note Heikki is away at the moment.
> > > >>
> > > >> That's OK.  I guess I can queue up this one for you.
> > > >>
> > > >> When do you need this to get into the Linus' tree?
> > > >=20
> > > > My patches are aiming for 3.19
> > >=20
> > > Actually it would be easier for me if Heikki's patch is already in
> > > 3.18, but all I need to know is when it will hit?
> >=20
> > I've applied the Heiki's patch and I'm going to push it for 3.18-rc2.
> 
> I had this queued for v3.19 with your Ack. It didn't feel like it should
> be in v3.18-rc as it's not really fixing any bug. In any case, fine by
> me; I'll drop it from my queue.

OK, thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
