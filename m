Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbaEHGUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 02:20:33 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:48589 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbaEHGUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 02:20:32 -0400
MIME-Version: 1.0
In-Reply-To: <fc783f97-fe3c-4887-a821-48f2e21759ad@email.android.com>
References: <1399509100-27169-1-git-send-email-dbasehore@chromium.org>
	<fc783f97-fe3c-4887-a821-48f2e21759ad@email.android.com>
Date: Wed, 7 May 2014 23:20:31 -0700
X-Google-Sender-Auth: ev-E-2h1ZuqxjymeleXXQR1Aq8E
Message-ID: <CAGAzgsorawC_+xDbKEKJ7QD_s9KRUxCzgrCUquVn9dKBPbvuYA@mail.gmail.com>
Subject: Re: [PATCH] tpm: Fix tpm init with no ACPI entry
From: "dbasehore ." <dbasehore@chromium.org>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a regression introduced in "ACPI / TPM: match node name
instead of full path when searching for TPM device" which was authored
on December 19, 2013.

On Wed, May 7, 2014 at 11:09 PM, Peter Huewe <peterhuewe@gmx.de> wrote:
> Hi Derek,
> Is this a regression?
> Do you know since when?
> Thanks
> Peter
> ---
> Sent from my mobile.
