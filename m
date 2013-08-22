Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab3HVVfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 17:35:37 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:44115 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436Ab3HVVfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 17:35:34 -0400
MIME-Version: 1.0
In-Reply-To: <1808554.Og9bqVFP8Z@vostro.rjw.lan>
References: <1377196271-20427-1-git-send-email-felipe.contreras@gmail.com>
	<1808554.Og9bqVFP8Z@vostro.rjw.lan>
Date: Thu, 22 Aug 2013 16:35:33 -0500
Message-ID: <CAMP44s3g_OyyJsFyV2bmEL=WugxmLXjMQU_xAmnSGvmVDtpGzQ@mail.gmail.com>
Subject: Re: [RESEND/PATCH] acpi: video: remove unused code
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, Zhang Rui <rui.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 4:38 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, August 22, 2013 01:31:11 PM Felipe Contreras wrote:
>> _BCM_use_index and _BCL_use_index are never used and probably never will.
>>
>> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
>
> I have this patch in the linux-next branch, although under a different subject.

Ah, I thought the lack of reply meant it wasn't picked.

-- 
Felipe Contreras
