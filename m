Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764504Ab3DDSZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 14:25:43 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:59311 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764462Ab3DDSZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 14:25:41 -0400
MIME-Version: 1.0
In-Reply-To: <515CC01C.3070502@pobox.com>
References: <CAMHSBOVZ7w51+8B=LyNBdeqP2BEYaNMDX3_WbEzUYqjdn2FZFg@mail.gmail.com>
	<1364536609-17398-1-git-send-email-gwendal@google.com>
	<515CC01C.3070502@pobox.com>
Date: Thu, 4 Apr 2013 11:25:40 -0700
Message-ID: <CAMHSBOWLwAzcB71RoNcMQMWx1Gv2fzerRNMV0oo90=2-7N=f7w@mail.gmail.com>
Subject: Re: [PATCH] [libata] Fix HDIO_DRIVE_CMD ioctl sense data check
From: Gwendal Grignou <gwendal@google.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Ken Moffat <zarniwhoop@ntlworld.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jeff Garzik <jgarzik@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you.
Gwendal.

On Wed, Apr 3, 2013 at 4:49 PM, Jeff Garzik <jgarzik@pobox.com> wrote:
> On 03/29/2013 01:56 AM, Gwendal Grignou wrote:
>>
>> commit 84a9a8cd9d0aa93c17e5815ab8a9cc4c0a765c63 changed the sense key
>> used for returning task registers, but HDIO_DRIVE_CMD ioctl was
>> not changed accordingly.
>>
>> Tested: check that SMART ENABLE sent using HDIO_DRIVE_CMD returns 0
>> instead of EIO.
>>
>> Signed-off-by: Gwendal Grignou <gwendal@google.com>
>> ---
>>   drivers/ata/libata-scsi.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>
>
> applied the version from Krzysztof Mazur, which covered both cases
>
>
>
