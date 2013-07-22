Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012Ab3GVJEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 05:04:08 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:51849 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756948Ab3GVJEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 05:04:05 -0400
Message-ID: <1374483843.15242.17.camel@x61.thuisdomein>
Subject: Re: [PATCH] lustre:libcfs: remove redundant code.
From: Paul Bolle <pebolle@tiscali.nl>
To: "Peng, Tao" <tao.peng@emc.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexandru Juncu <alexj@rosedu.org>, Pekka Enberg <penberg@kernel.org>,
        "andreas.dilger" <andreas.dilger@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 22 Jul 2013 11:04:03 +0200
In-Reply-To: <1882637210201641A747464075FFC6490E5A7562@MX101CL02.corp.emc.com>
References: <1374245148-24031-1-git-send-email-alexj@rosedu.org>
	 <CAOJsxLGEmjY6wTp99DKQ4ZKO2oXq6102MczbjCHTUReuCTq-fw@mail.gmail.com>
	 <CAPhGq=b6_7=i3e=9gkT9s5JZ+hAPcu8T_S+M9Yt60nt3vA6Nrw@mail.gmail.com>
	 <CAOJsxLFw4t-jwO4vDuMYfZA4uqH59h1c66xVPPFDO037OvGKSg@mail.gmail.com>
	 <CAPhGq=Y30i0RWJTcomt5sRdKX6RDzdGHBo5L9D6coH8O0ej6kA@mail.gmail.com>
	 <20130719154648.GA23116@kroah.com>
	 <1374250046.15242.7.camel@x61.thuisdomein>
	 <1882637210201641A747464075FFC6490E5A7562@MX101CL02.corp.emc.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jul 2013 09:04:04.0487 (UTC) FILETIME=[6A3EE970:01CE86BA]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-22 at 02:07 +0000, Peng, Tao wrote:
> Paul Bolle [mailto:pebolle@tiscali.nl]
> > I ask because I noticed that "drivers/staging/lustre/lustre/ptlrpc/gss/"
> > is only built if CONFIG_PTLRPC_GSS is set. But the corresponding Kconfig
> > symbol is nowhere to be found.
> > 
> That's my fault. We certainly _want_ the ptlrpc gss code. I'll get it fixed.

I'll stop worrying about it. But if little has changed by, say, early
2014, I might try to prod you again.

Thanks!


Paul Bolle

