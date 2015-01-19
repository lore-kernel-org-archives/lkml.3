Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbbASBPO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 20:15:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:26590 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbbASBPN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 20:15:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,422,1418112000"; 
   d="scan'208";a="652956373"
From: "Tang, Feng" <feng.tang@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        John Stultz <john.stultz@linaro.org>, Colin Cross <ccross@android.com>,
        Heesub Shin <heesub.shin@samsung.com>,
        Mitchel Humpherys <mitchelh@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] staging: andriod: ion: Add ion_phys_get_by_id
 function
Thread-Topic: [PATCH 1/2] staging: andriod: ion: Add ion_phys_get_by_id
 function
Thread-Index: AQHQJ+5RqZncMrfR0k2l+PFlMGRqW5yxEK2AgACcvtCAEuE3AIACKxrA
Date: Mon, 19 Jan 2015 01:14:49 +0000
Message-ID: <A74E4C03C808B649AF1F11527F2D44140510FC7D@SHSMSX101.ccr.corp.intel.com>
References: <1420355512-31129-1-git-send-email-feng.tang@intel.com>
 <20150105142433.1d892039@lxorguk.ukuu.org.uk>
 <A74E4C03C808B649AF1F11527F2D4414050FD0E1@SHSMSX101.ccr.corp.intel.com>
 <20150118000418.GA1791@kroah.com>
In-Reply-To: <20150118000418.GA1791@kroah.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Thanks for your review.

> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Sunday, January 18, 2015 8:04 AM
> To: Tang, Feng
> Cc: One Thousand Gnomes; John Stultz; Colin Cross; Heesub Shin; Mitchel
> Humpherys; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/2] staging: andriod: ion: Add ion_phys_get_by_id
> function
>
> > >
> > > On Sun,  4 Jan 2015 15:11:51 +0800
> > > Feng Tang <feng.tang@intel.com> wrote:
> > >
> > > > There is user case that user only knows the ion_handle idand
> > > > needs to get the physical addr and len. So add this wrapper to
> > > > meet this requirement.
> > >
> > > What is the in-tree upstream user of this new function ? I don't see one
> > > in your patches ?
> >
> > That's true. We are working on enabling a new platform which heavily
> > uses ION and some driver needs to use this API, so I guess there is some
> > other plaforms may have the similar requirements. If you think this patch
> > should be merged after there is an in-tree user, I'm OK with it :)
> >
> > I assume that driver's author will start to push his drivers in batch soon.
> 
> We need to see those patches first, we can't add apis for no in-tree
> user, otherwise they will just get ripped out.
I see. I'll repost this patch after our "user" driver get merged.

How about the 2/2 patch, which improve the profiling info through
debugfs?
	[PATCH 2/2] staging: android: ion: Add pss info for each ion_client

Thanks,
Feng

