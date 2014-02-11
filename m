Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354AbaBKItM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 03:49:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37261 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaBKItJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 03:49:09 -0500
Subject: Re: [lm-sensors] [PATCH] hwmon: (max6650) Rename the device ids to
 contain the hwmon suffix
From: Jean Delvare <jdelvare@suse.de>
To: Laszlo Papp <lpapp@kde.org>
Cc: Lee Jones <lee.jones@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        lm-sensors@lm-sensors.org
In-Reply-To: <CAOMwXhMhKdp420+SPTih+C3fAgTmrpJgPnGBxsfPO3pEhESGTA@mail.gmail.com>
References: <1392045953-26596-1-git-send-email-lpapp@kde.org>
	 <20140210160842.GB26997@lee--X1> <20140210173811.04ba5964@endymion.delvare>
	 <CAOMwXhPTkrUUaUL-H_0fvZBO9_kt4jqKXs5BJYthDfu0_1c3xg@mail.gmail.com>
	 <20140211085014.4ef32b56@endymion.delvare>
	 <CAOMwXhMhKdp420+SPTih+C3fAgTmrpJgPnGBxsfPO3pEhESGTA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Tue, 11 Feb 2014 09:49:05 +0100
Message-ID: <1392108545.4700.4.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Tuesday 11 February 2014 à 08:28 +0000, Laszlo Papp a écrit :
> On Tue, Feb 11, 2014 at 7:50 AM, Jean Delvare <jdelvare@suse.de> wrote:
> > Hi Laszlo,
> >
> > On Tue, 11 Feb 2014 03:13:37 +0000, Laszlo Papp wrote:
> >> On Mon, Feb 10, 2014 at 4:38 PM, Jean Delvare <jdelvare@suse.de> wrote:
> >> > Additionally, dashes are explicitly forbidden in hwmon
> >> > device names.
> >>
> >> Also, where is that documented?
> >
> > In Documentation/hwmon/sysfs-interface:
> >
> > *********************
> > * Global attributes *
> > *********************
> >
> > name            The chip name.
> >                 This should be a short, lowercase string, not containing
> >                 spaces nor dashes, representing the chip name. This is
> >                 the only mandatory attribute.
> >                 I2C devices get this attribute created automatically.
> >                 RO
> 
> Time to revisit this decision....
> 
> So, based on the fact that children device names usually contain
> dashes, I do not understand why hwmon would be any special in this
> regard. It is possible that the hwmon developers have not faced much
> MFD situation before, and so, this was not considered to be handled
> like in other subsystems.
> 
> I am proposing to change this "rule"...  Any objection?

I'm giving up here, sorry. There's no point in me writing any more on
the topic as you are not listening to me. I do not have the impression
you are doing any effort to understand what I'm saying. Plus you keep
focusing on things that do not matter and problems for which a solution
has already been provided. So wherever you're going, this is without me.

-- 
Jean Delvare
Suse L3 Support

