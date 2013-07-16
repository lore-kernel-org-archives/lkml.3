Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083Ab3GPPm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 11:42:28 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:60914 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932716Ab3GPPm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 11:42:27 -0400
MIME-Version: 1.0
In-Reply-To: <1373988586.17662.4.camel@x61.thuisdomein>
References: <1373879920.2591.13.camel@x61.thuisdomein>
	<1373914081.2591.40.camel@x61.thuisdomein>
	<CAC5umyj2bOyU_z0HVawXL7k4FmF9oHh1yZfHExbKn9ck85RsUQ@mail.gmail.com>
	<1373988586.17662.4.camel@x61.thuisdomein>
Date: Wed, 17 Jul 2013 00:42:26 +0900
Message-ID: <CAC5umyioeYDxFVs5J8fvPmXWOB8k9dp_qCp8Ntcq_d8cKhkS9g@mail.gmail.com>
Subject: Re: [PATCH v2] [SCSI] scsi_debug: silence GCC warning
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/17 Paul Bolle <pebolle@tiscali.nl>:
> On Wed, 2013-07-17 at 00:21 +0900, Akinobu Mita wrote:
>> This one looks good to me.
>
> Thanks.
>
>> It would be much better if this commit
>> log had a reference to the commit that introduced this warning as
>> you described after '---' in v1 patch.
>
> Do you mean that I should submit a v3, with a commit explanation that
> also has one or two lines that mention commit beb40ea42b ("[SCSI]
> scsi_debug: reduce duplication between prot_verify_read and
> prot_verify_write")?

Yes.  I think it will help someone to understand the background of this patch.
