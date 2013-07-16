Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165Ab3GPP3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 11:29:50 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:50118 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932241Ab3GPP3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 11:29:49 -0400
Message-ID: <1373988586.17662.4.camel@x61.thuisdomein>
Subject: Re: [PATCH v2] [SCSI] scsi_debug: silence GCC warning
From: Paul Bolle <pebolle@tiscali.nl>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>
Date: Tue, 16 Jul 2013 17:29:46 +0200
In-Reply-To: <CAC5umyj2bOyU_z0HVawXL7k4FmF9oHh1yZfHExbKn9ck85RsUQ@mail.gmail.com>
References: <1373879920.2591.13.camel@x61.thuisdomein>
	 <1373914081.2591.40.camel@x61.thuisdomein>
	 <CAC5umyj2bOyU_z0HVawXL7k4FmF9oHh1yZfHExbKn9ck85RsUQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jul 2013 15:29:47.0261 (UTC) FILETIME=[4DEF7AD0:01CE8239]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-17 at 00:21 +0900, Akinobu Mita wrote:
> This one looks good to me.

Thanks.

> It would be much better if this commit
> log had a reference to the commit that introduced this warning as
> you described after '---' in v1 patch.

Do you mean that I should submit a v3, with a commit explanation that
also has one or two lines that mention commit beb40ea42b ("[SCSI]
scsi_debug: reduce duplication between prot_verify_read and
prot_verify_write")?


Paul Bolle

