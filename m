Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab3DLPGF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 11:06:05 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:33022 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab3DLPGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 11:06:03 -0400
MIME-Version: 1.0
In-Reply-To: <20130411132547.cd0df05abeea6a7f49646b0c@linux-foundation.org>
References: <1364995248-11028-1-git-send-email-octavian.purdila@intel.com>
	<20130411132547.cd0df05abeea6a7f49646b0c@linux-foundation.org>
Date: Fri, 12 Apr 2013 18:06:01 +0300
Message-ID: <CAE1zotKFr6MYpohTGx8Xpmak0NXNEvjTVbGAW-TKnCtnmGQRaw@mail.gmail.com>
Subject: Re: [PATCH v2] aio: convert the ioctx list to radix tree
From: Octavian Purdila <octavian.purdila@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-s390@vger.kernel.org, Kent Overstreet <koverstreet@google.com>,
        bcrl@kvack.org, schwidefsky@de.ibm.com,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 11:25 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed,  3 Apr 2013 16:20:48 +0300 Octavian Purdila <octavian.purdila@intel.com> wrote:
>
>> This patchs converts the ioctx list to a radix tree.
>
> This looks rather nice, but unfortunately all the pending aio work in
> -mm/linux-next totally messes it up.
>
> Could you please redo and retest it over the pending work?  Perhaps
> after 3.10-rc1 would be a convenient time.
>

Hi Andrew,

Thanks for taking a look at this. I did test it against next/akpm HEAD
a couple of weeks ago to see how it perform vs the new aio work from
Kent, and is still looking good :) I will redo it and test it for the
current next-apkm head and resend it to you.

Tavi
