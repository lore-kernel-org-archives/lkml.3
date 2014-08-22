Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241AbaHVPmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 11:42:23 -0400
Received: from exprod7og101.obsmtp.com ([64.18.2.155]:40039 "EHLO
	exprod7og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130AbaHVPmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 11:42:22 -0400
MIME-Version: 1.0
In-Reply-To: <yq1k361r1l7.fsf@sermon.lab.mkp.net>
References: <20140625104207.GA13042@avagotech.com>
	<yq1a98av9vi.fsf@sermon.lab.mkp.net>
	<CAK=zhgqGVBsgxheZ1ixvGEeOFJ_7fPhO0d4HAh1f4YD1mWG7Sw@mail.gmail.com>
	<yq1k361r1l7.fsf@sermon.lab.mkp.net>
Date: Fri, 22 Aug 2014 21:12:20 +0530
Message-ID: <CAK=zhgqWWKu4bNw3WB3cG120cC5fXcVfjRaigdARxnHa=maeQw@mail.gmail.com>
Subject: Re: [RESEND][PATCH 8/8][SCSI]mpt3sas: Bump mpt3sas driver version to 04.100.00.00
From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jejb@kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org,
        Sathya Prakash <Sathya.Prakash@avagotech.com>,
        Nagalakshmi Nandigama <Nagalakshmi.Nandigama@avagotech.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

Today I was busy with the internal activity. By Monday I will repost
this patch with requested changes.

Thanks,
Sreekanth

On Fri, Aug 22, 2014 at 2:40 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:
>
> Sreekanth> 1. [RESEND][PATCH 7/8][SCSI]mpt3sas: Added Reply Descriptor
> Sreekanth>    Post Queue (RDPQ) Array support
>
> Please make the change suggested by Joe Perches and then repost both
> mpt2sas and mpt3sas with the appropriate SoB and RB tags so they are
> easy for Christoph to pick up.
>
> The only patch I'd like to dig deeper into before accepting it is the
> unblock one.
>
> --
> Martin K. Petersen      Oracle Linux Engineering
