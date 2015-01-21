Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbbAUOSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 09:18:23 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59060 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751972AbbAUOSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 09:18:16 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Ken Xue <Ken.Xue@amd.com>, linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Heikki Krogerus <heikki.krogerus@intel.com>
Subject: Re: [PATCH 1/3 V3] acpi:soc: merge common codes for creating platform device
Date: Wed, 21 Jan 2015 15:40:50 +0100
Message-ID: <3669963.UdpNKcqJC1@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAHp75VfAAF2bTaMY32QLtsAGZGSw+D073eA4GDrjNO37=hgUfA@mail.gmail.com>
References: <1418892285.17614.6.camel@kxue-X58A-UD3R> <20150121100901.GK1850@lahna.fi.intel.com> <CAHp75VfAAF2bTaMY32QLtsAGZGSw+D073eA4GDrjNO37=hgUfA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 21, 2015 12:26:28 PM Andy Shevchenko wrote:
> On Wed, Jan 21, 2015 at 12:09 PM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> > On Tue, Jan 20, 2015 at 04:12:16PM +0100, Rafael J. Wysocki wrote:
> >> On Thursday, December 18, 2014 04:44:45 PM Ken Xue wrote:
> >> >
> >> > This patch is supposed to deliver some common codes for AMD APD and
> >> > intel LPSS. It can help to convert some specific acpi devices to be
> >> > platform devices.
> >> >
> >> > Signed-off-by: Ken Xue <Ken.Xue@amd.com>
> >>
> >> Mika, is the v3 fine with you?
> >
> > Yup, no objections from me.
> >
> > Andy, Heikki, do you have any comments?
> 
> There are style issues, mostly in the comments. I could review them,
> but I really have not much time for that.

OK, no worries, I can take care of these.

Thanks guys!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
