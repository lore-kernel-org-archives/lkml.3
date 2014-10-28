Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbaJ1WZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:25:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59860 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbaJ1WZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:25:18 -0400
Date: Tue, 28 Oct 2014 22:25:16 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: i8042 - add mux quirk for HP EliteBook 8470p
Message-ID: <20141028222516.GA4265@hercules>
References: <1414525704-8409-1-git-send-email-luis.henriques@canonical.com>
 <20141028201046.GB7461@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141028201046.GB7461@dtor-ws>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 01:10:46PM -0700, Dmitry Torokhov wrote:
> Hi Luis,
> 
> On Tue, Oct 28, 2014 at 07:48:24PM +0000, Luis Henriques wrote:
> > This laptop requires active multiplexing to be enabled in order to be able
> > to separate the PS/2 mouse and the touchpad.
> > 
> > Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> > ---
> >  drivers/input/serio/i8042-x86ia64io.h | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
> > index a0bcbb64d06d..34b95e4268eb 100644
> > --- a/drivers/input/serio/i8042-x86ia64io.h
> > +++ b/drivers/input/serio/i8042-x86ia64io.h
> > @@ -220,6 +220,13 @@ static const struct dmi_system_id __initconst i8042_dmi_mux_table[] = {
> >  			DMI_MATCH(DMI_PRODUCT_NAME, "CF-18"),
> >  		},
> >  	},
> > +	{
> > +		/* HP EliteBook 8470p */
> > +		.matches = {
> > +			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
> > +			DMI_MATCH(DMI_PRODUCT_NAME, "HP EliteBook 8470p"),
> 
> Hmm, so the tide is turning the other way ;) I think I'll be comfortable
> extending this to all EliteBooks as I know 840 and 1040 work as well and
> I have not heard any other complaints about this model line.
> 
> Cold you resend with match on "HP EliteBook" instead of "HP EliteBook
> 8470p"?
> 

Sure, sending it in a minute.

Cheers,
--
Luís

> Thanks.
> 
> -- 
> Dmitry
