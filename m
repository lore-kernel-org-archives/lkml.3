Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbbAGLdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 06:33:07 -0500
Received: from mga03.intel.com ([134.134.136.65]:51302 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985AbbAGLdC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 06:33:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="437485828"
From: "Dilger, Andreas" <andreas.dilger@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC: "Drokin, Oleg" <oleg.drokin@intel.com>,
        "HPDD-discuss@ml01.01.org" <HPDD-discuss@ml01.01.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        OSUOSL Drivers <devel@driverdev.osuosl.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: lustre/lnet/lnet/lib-move.c: memcpy with (struct
 iovec*)->iov_base, which is __user
Thread-Topic: lustre/lnet/lnet/lib-move.c: memcpy with (struct
 iovec*)->iov_base, which is __user
Thread-Index: AQHQKgLkt1vkC4ZL3keuW3w1+SLWXZy03EQA//+73oA=
Date: Wed, 7 Jan 2015 11:32:59 +0000
Message-ID: <D0D2667E.D2C25%andreas.dilger@intel.com>
References: <CANZNk80SoQZU994psVKuuGRGGHnGgO7bcFpPBQoGyg=CjW77xw@mail.gmail.com>
 <20150107083654.GK15033@mwanda>
In-Reply-To: <20150107083654.GK15033@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.188.251]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3662E1D38E8E064E933B3D008E3AE393@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/01/07, 1:36 AM, "Dan Carpenter" <dan.carpenter@oracle.com> wrote:
> Didn't Al change these to kvec instead of iovec?  You have to look at
> the callers to figure out if it's actually a user space pointer or a
> kernel pointer.

A patch was sent by Al on Dec 2 to replace iovec with kvec, in a thread
titled "[PATCH] staging:lustre:lnet: Incorrect type in assignment".  Greg
replied on Dec 10 in another thread (also fixing this same warning) titled
"[PATCH] staging: lustre: Fix the warning messages about casting without
__user macro" that Al's patch was in the staging tree for 3.19-rc1.

Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


