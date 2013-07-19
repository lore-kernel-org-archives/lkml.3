Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760627Ab3GSQXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 12:23:15 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:59949 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759422Ab3GSQXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 12:23:14 -0400
MIME-Version: 1.0
In-Reply-To: <1374250046.15242.7.camel@x61.thuisdomein>
References: <1374245148-24031-1-git-send-email-alexj@rosedu.org>
 <CAOJsxLGEmjY6wTp99DKQ4ZKO2oXq6102MczbjCHTUReuCTq-fw@mail.gmail.com>
 <CAPhGq=b6_7=i3e=9gkT9s5JZ+hAPcu8T_S+M9Yt60nt3vA6Nrw@mail.gmail.com>
 <CAOJsxLFw4t-jwO4vDuMYfZA4uqH59h1c66xVPPFDO037OvGKSg@mail.gmail.com>
 <CAPhGq=Y30i0RWJTcomt5sRdKX6RDzdGHBo5L9D6coH8O0ej6kA@mail.gmail.com>
 <20130719154648.GA23116@kroah.com> <1374250046.15242.7.camel@x61.thuisdomein>
From: Alexandru Juncu <alexj@rosedu.org>
Date: Fri, 19 Jul 2013 19:22:53 +0300
X-Google-Sender-Auth: a3ZFeoX0KCrqocc0Jcs2cEGuadU
Message-ID: <CAPhGq=YW671ey1MUih_O2=2r-gjVVo8v=ac7nYrsHQ232KoxOw@mail.gmail.com>
Subject: Re: [PATCH] lustre:libcfs: remove redundant code.
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        "andreas.dilger" <andreas.dilger@intel.com>,
        "tao.peng" <tao.peng@emc.com>, driverdev <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 July 2013 19:07, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Fri, 2013-07-19 at 08:46 -0700, Greg Kroah-Hartman wrote:
>> Doesn't matter, if there are no users, please just remove it.
>
> Is that, basically, your approach to staging cleanups?
>
> I ask because I noticed that "drivers/staging/lustre/lustre/ptlrpc/gss/"
> is only built if CONFIG_PTLRPC_GSS is set. But the corresponding Kconfig
> symbol is nowhere to be found.
>
> Or do you prefer that I poke the people involved in (this case in)
> Lustre before suggesting a drastic cleanup like that?



Thanks for the comments!

The comment for that function is "Duplicate a string in a
platform-independent way" so it might be because it's called by code
that also run on non-Linux systems.
