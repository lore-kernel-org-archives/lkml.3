Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbaA3Pw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 10:52:29 -0500
Received: from www84.your-server.de ([213.133.104.84]:48070 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbaA3Pw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 10:52:28 -0500
Message-ID: <1391097193.2898.6.camel@wall-e.seibold.net>
Subject: Re: [PATCH 3/4] Add 32 bit VDSO support for 32 kernel
From: Stefani Seibold <stefani@seibold.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, ak@linux.intel.com,
        aarcange@redhat.com, john.stultz@linaro.org, luto@amacapital.net,
        xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Date: Thu, 30 Jan 2014 16:53:13 +0100
In-Reply-To: <52EA7000.8010002@zytor.com>
References: <1391078953-1575-1-git-send-email-stefani@seibold.net>
	 <1391078953-1575-4-git-send-email-stefani@seibold.net>
	 <52EA7000.8010002@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 30.01.2014, 07:30 -0800 schrieb H. Peter Anvin:
> On 01/30/2014 02:49 AM, stefani@seibold.net wrote:
> > From: Stefani Seibold <stefani@seibold.net>
> > 
> > This patch add the support for 32 bit VDSO to a 32 bit kernel.
> > 
> > For 32 bit programs running on a 32 bit kernel, the same mechanism is
> > used as for 64 bit programs running on a 64 bit kernel.
> > 
> > Signed-off-by: Stefani Seibold <stefani@seibold.net>
> 
> The subject line of these two patches is misleading as hell... we
> already have a vdso.
> 

Yes, a very tiny one. I will fix it in the next version.


