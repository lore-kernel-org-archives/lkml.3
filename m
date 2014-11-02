Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaKBHr2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 02:47:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57952 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaKBHrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 02:47:24 -0500
MIME-Version: 1.0
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C2B80DB80@PGSMSX102.gar.corp.intel.com>
References: <1414131502-13886-1-git-send-email-hock.leong.kweh@intel.com>
	<1414131502-13886-2-git-send-email-hock.leong.kweh@intel.com>
	<CACVXFVOu2MyeRyyQybdAUEmp02mGHP6-kmHZ8EBx4=uJiF51LQ@mail.gmail.com>
	<F54AEECA5E2B9541821D670476DAE19C2B80DB80@PGSMSX102.gar.corp.intel.com>
Date: Sun, 2 Nov 2014 15:47:20 +0800
Message-ID: <CACVXFVMgd9Jzsf-pyqt5+DmtXNeRjY1UuHC6DYg6Zk9rOc9dUw@mail.gmail.com>
Subject: Re: [PATCH v1 1/3] firmware loader: Introduce new API - request_firmware_abort()
From: Ming Lei <ming.lei@canonical.com>
To: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Cc: "Fleming, Matt" <matt.fleming@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 11:04 AM, Kweh, Hock Leong
<hock.leong.kweh@intel.com> wrote:
>> -----Original Message-----
>> From: Ming Lei [mailto:ming.lei@canonical.com]
>> Sent: Monday, October 27, 2014 12:00 AM
>>
>> You can call fw_lookup_buf() directly, otherwise feel free to add:
>>
>> Acked-by: Ming Lei <ming.lei@canonical.com>
>>
>
> Hi Ming Lei,
>
> The fw_lookup_buf() is defined inside the conditional preprocessor directive for CONFIG_PM_SLEEP.
> Since the request_firmware_abort() may not only be used in PM_SLEEP, could I move the fw_lookup_buf()
> out from the CONFIG_PM_SLEEP block if we want to call fw_lookup_buf() instead of __fw_lookup_buf()?

Sure.

Thanks,
