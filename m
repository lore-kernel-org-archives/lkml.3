Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab3GSQHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 12:07:30 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:55762 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751340Ab3GSQH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 12:07:28 -0400
Message-ID: <1374250046.15242.7.camel@x61.thuisdomein>
Subject: Re: [PATCH] lustre:libcfs: remove redundant code.
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexandru Juncu <alexj@rosedu.org>, Pekka Enberg <penberg@kernel.org>,
        "andreas.dilger" <andreas.dilger@intel.com>,
        "tao.peng" <tao.peng@emc.com>, driverdev <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 19 Jul 2013 18:07:26 +0200
In-Reply-To: <20130719154648.GA23116@kroah.com>
References: <1374245148-24031-1-git-send-email-alexj@rosedu.org>
	 <CAOJsxLGEmjY6wTp99DKQ4ZKO2oXq6102MczbjCHTUReuCTq-fw@mail.gmail.com>
	 <CAPhGq=b6_7=i3e=9gkT9s5JZ+hAPcu8T_S+M9Yt60nt3vA6Nrw@mail.gmail.com>
	 <CAOJsxLFw4t-jwO4vDuMYfZA4uqH59h1c66xVPPFDO037OvGKSg@mail.gmail.com>
	 <CAPhGq=Y30i0RWJTcomt5sRdKX6RDzdGHBo5L9D6coH8O0ej6kA@mail.gmail.com>
	 <20130719154648.GA23116@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Jul 2013 16:07:27.0041 (UTC) FILETIME=[101BCB10:01CE849A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-19 at 08:46 -0700, Greg Kroah-Hartman wrote:
> Doesn't matter, if there are no users, please just remove it.

Is that, basically, your approach to staging cleanups?

I ask because I noticed that "drivers/staging/lustre/lustre/ptlrpc/gss/"
is only built if CONFIG_PTLRPC_GSS is set. But the corresponding Kconfig
symbol is nowhere to be found.

Or do you prefer that I poke the people involved in (this case in)
Lustre before suggesting a drastic cleanup like that?


Paul Bolle

