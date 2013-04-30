Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759728Ab3D3JK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 05:10:57 -0400
Received: from shutemov.name ([204.155.152.216]:37883 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759102Ab3D3JK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 05:10:56 -0400
Date: Tue, 30 Apr 2013 13:04:31 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Serban Constantinescu <Serban.Constantinescu@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "arve@android.com" <arve@android.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>
Subject: Re: [PATCH v3 0/6] Android Binder IPC Fixes
Message-ID: <20130430100431.GA3973@shutemov.name>
References: <1365769555-6052-1-git-send-email-serban.constantinescu@arm.com>
 <20130430073145.GA3623@shutemov.name>
 <517F8652.4070103@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517F8652.4070103@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 09:52:34AM +0100, Serban Constantinescu wrote:
> Hi Kirill,
> 
> On 30/04/13 08:31, Kirill A. Shutemov wrote:
> >On Fri, Apr 12, 2013 at 01:25:49PM +0100, Serban Constantinescu wrote:
> >>The patch set has been successfully tested with a 64bit Linux userspace and
> >>64bit binder unit-tests.
> >>
> >>This patch set has been successfully tested on 32bit platforms(ARMv7 VExpress)
> >>and 64bit platforms(ARMv8 RTSM) running a 32bit Android userspace and an in
> >>kernel binder compat layer.
> >
> >I've tried to replace ugly hack with your patches to be able to boot
> >32-bit userspace on x86-64. It fails. :(
> >
> 
> This patch set fixes the binder interface so that it works on 32/32
> or 64/64 systems and preps the driver for the compat layer - 64bit
> kernel/32bit userspace. As discussed with the Android developers the
> binder compat will live in the userspace.

Does the compat layer already exist or it's a plan?

-- 
 Kirill A. Shutemov
