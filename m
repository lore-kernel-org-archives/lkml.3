Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab3C0UDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 16:03:00 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:44565 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab3C0UC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 16:02:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo7iUsV4ca0vhs085_prsTXBEvuTnuw1O_NUr-CvUytYGQ@mail.gmail.com>
References: <kg69ef$vdb$1@ger.gmane.org>
	<CAPM=9ty0Apsk_5v+aguHQMzFhi9A9kMcWb8fXBmWus9Z=tA=JA@mail.gmail.com>
	<5126C3E1.80801@gmail.com>
	<513BACAC.9050800@gmail.com>
	<CA+55aFyOypoeXgBWP0d7KmL3YezmjwEgrB=ntZaZdYjdmFkQpA@mail.gmail.com>
	<20130319195950.GA16828@srcf.ucam.org>
	<CA+55aFy9nbc+9VyCg0BA9E85sRwksQXvu6Wqgurf5omv2mPtZw@mail.gmail.com>
	<5148D5C8.2000701@gmail.com>
	<CAPM=9tyYMSsK_2eCNRTx5EsgAQtnvmHxhgPHP3GHPxKUn+wo5w@mail.gmail.com>
	<20130325235525.GA3423@srcf.ucam.org>
	<CAErSpo7iUsV4ca0vhs085_prsTXBEvuTnuw1O_NUr-CvUytYGQ@mail.gmail.com>
Date: Thu, 28 Mar 2013 06:02:57 +1000
Message-ID: <CAPM=9tzmqof4Rzec_2bVm+UxH86Zas6JhgizfzHNfnvrsvhoYA@mail.gmail.com>
Subject: Re: Regression: Screen turns off when booting in EFI mode
From: Dave Airlie <airlied@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Garrett <mjg@redhat.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ben Skeggs <skeggsb@gmail.com>, bugzilla@colorremedies.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> That RedHat bugzilla is from kernel-3.9.0-0.rc4.git0.1.fc19.x86_64.
> Does that kernel include Matthew's patch from Mar 19?  I'm wondering
> if that report is for the same problem Mantas saw and possibly would
> be *fixed* by the Mar 19 patch, or if it is for a problem with the Mar
> 19 patch itself.
>
> I would check this myself, but I don't know how to figure out what's
> in kernel-3.9.0-0.rc4.git0.1.fc19.x86_64.

Its 3.9-rc4 + a git snapshot one day after,

>From what I can see 3.9-rc4 contains this patch from Mar 19.

Dave.
