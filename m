Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab3KOKcx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 05:32:53 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:33730 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab3KOKcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 05:32:46 -0500
MIME-Version: 1.0
In-Reply-To: <20131115042651.GA18697@kroah.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
 <1384446782-13741-2-git-send-email-bergwolf@gmail.com> <20131115042651.GA18697@kroah.com>
From: Peng Tao <bergwolf@gmail.com>
Date: Fri, 15 Nov 2013 18:32:24 +0800
Message-ID: <CA+a=Yy5VNMshK2d8Rq+PYM6ycX+NL0Tt0HgTmZHbaUBu_wjMWw@mail.gmail.com>
Subject: Re: [PATCH 01/39] staging/lustre/hsm: remove hsm_nl proc file
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "John L. Hammond" <john.hammond@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 12:26 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Fri, Nov 15, 2013 at 12:32:24AM +0800, Peng Tao wrote:
>> From: "John L. Hammond" <john.hammond@intel.com>
>>
>> Remove the file /proc/fs/lustre/mdc/*/hsm_nl which was introduced "for
>> testing purposes."
>
> What does this mean?  Why is this allowed?  How do you know no one uses
> it?  I need a much better changelog comment here, sorry.
>
Those proc entries were added for testing HSM
(http://en.wikipedia.org/wiki/Hierarchical_storage_management) during
the time of developing Lustre HSM feature. Now the HSM feature is
almost completed, those files no longer serve their purpose and can be
removed so that no one would develop dependency upon it after Lustre
HSM is announced released.

I'll add this to the commit message.

Thanks for reviewing,
Tao
