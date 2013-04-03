Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab3DCXtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 19:49:52 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:39602 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659Ab3DCXtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 19:49:51 -0400
Message-ID: <515CC01C.3070502@pobox.com>
Date: Wed, 03 Apr 2013 19:49:48 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Gwendal Grignou <gwendal@google.com>
CC: zarniwhoop@ntlworld.com, linux-kernel@vger.kernel.org, jgarzik@redhat.com
Subject: Re: [PATCH] [libata] Fix HDIO_DRIVE_CMD ioctl sense data check
References: <CAMHSBOVZ7w51+8B=LyNBdeqP2BEYaNMDX3_WbEzUYqjdn2FZFg@mail.gmail.com> <1364536609-17398-1-git-send-email-gwendal@google.com>
In-Reply-To: <1364536609-17398-1-git-send-email-gwendal@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2013 01:56 AM, Gwendal Grignou wrote:
> commit 84a9a8cd9d0aa93c17e5815ab8a9cc4c0a765c63 changed the sense key
> used for returning task registers, but HDIO_DRIVE_CMD ioctl was
> not changed accordingly.
>
> Tested: check that SMART ENABLE sent using HDIO_DRIVE_CMD returns 0
> instead of EIO.
>
> Signed-off-by: Gwendal Grignou <gwendal@google.com>
> ---
>   drivers/ata/libata-scsi.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)

applied the version from Krzysztof Mazur, which covered both cases



