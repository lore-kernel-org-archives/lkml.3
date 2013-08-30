Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab3H3MbB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 08:31:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:29530 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755811Ab3H3MbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 08:31:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,990,1367996400"; 
   d="scan'208";a="388815432"
Date: Fri, 30 Aug 2013 14:30:57 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Chao Xie <xiechao.mail@gmail.com>
Cc: Chao Xie <chao.xie@marvell.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mfd: 88pm800: Fix the bug that pdata may be NULL
Message-ID: <20130830123057.GK20329@zurbaran>
References: <1376875675-11286-1-git-send-email-chao.xie@marvell.com>
 <1376875675-11286-2-git-send-email-chao.xie@marvell.com>
 <20130820014042.GF13324@zurbaran>
 <CADApbehFDH2-vJMHuVPq8i+zR0fm4ii36JNB_CEKaYEx0r23zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADApbehFDH2-vJMHuVPq8i+zR0fm4ii36JNB_CEKaYEx0r23zw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Xie,

On Tue, Aug 27, 2013 at 02:11:58PM +0800, Chao Xie wrote:
> On Tue, Aug 20, 2013 at 9:40 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> > Hi Xie,
> >
> > On Sun, Aug 18, 2013 at 09:27:54PM -0400, Chao Xie wrote:
> >> User pass platform data to device, and platform data may be
> >> NULL.
> > In which case do you get that ? With DT ?
> > Should rtc_init fail when pdata is NULL ?
> >
> > You need to explain that, be it only for us to know if it's a critical
> > fix or not.
> >
> Sorry for late response.
> If pdata is NULL, the driver will fail. 
The question is: Why would pdata be NULL ? If there's a fundamental
issue you're hiding with this patch, you probably want to fix the real
problem instead.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
