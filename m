Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbaHGAXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 20:23:15 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:54569 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbaHGAXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 20:23:12 -0400
MIME-Version: 1.0
In-Reply-To: <EE124450C0AAF944A40DD71E61F878C9910E57@SINEX14MBXC417.southpacific.corp.microsoft.com>
References: <1406903304-7256-1-git-send-email-decui@microsoft.com>
	<20140806203339.GA22889@core.coreip.homeip.net>
	<EE124450C0AAF944A40DD71E61F878C9910E57@SINEX14MBXC417.southpacific.corp.microsoft.com>
Date: Wed, 6 Aug 2014 17:23:11 -0700
Message-ID: <CAKdAkRRjPC3zx+Xud=RuXQuQLkUya89VOb+JBxhwsP9Vt=_cjA@mail.gmail.com>
Subject: Re: [PATCH] Input: hyperv-keyboard: register as a wakeup source
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dexuan Cui <decui@microsoft.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2014 at 5:19 PM, Dexuan Cui <decui@microsoft.com> wrote:
>
> > -----Original Message-----
> > From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> > Sent: Thursday, August 7, 2014 4:34 AM
> > To: Dexuan Cui
> > On Fri, Aug 01, 2014 at 07:28:24AM -0700, Dexuan Cui wrote:
> > > With this patch, we can press a key to wake up the VM after the VM
> > executes
> > > "echo freeze > /sys/power/state".
> > >
> > > This addresses part of
> > https://bugzilla.redhat.com/show_bug.cgi?id=1086100
> >
> > I am sorry but this bug is not open to the public. Please avoid
> > mentioning such bugs in changelogs. Otherwise I'll apply it.
> Hi Dmitry,
> Sorry, I didn't realize it's not public... :-)
>
> I'll remove the line and re-send the patch.
>

No need to resend, I already applied it.

Thanks.

-- 
Dmitry
