Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463AbaLPAEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 19:04:23 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:46943 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbaLPAEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 19:04:22 -0500
Message-ID: <548F7703.1060600@lwfinger.net>
Date: Mon, 15 Dec 2014 18:04:19 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jes Sorensen <Jes.Sorensen@redhat.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: rtl8723au: os_dep: usb_intf.c: Fix for possible
 null pointer dereference
References: <1418596754-24735-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <20141215103117.GC4856@mwanda> <wrfjbnn4vrqa.fsf@redhat.com> <CAFo99gZOr=1z8J_gNNRLXnKNBEiPCE_G3=ryaN5hAHvewHf0_w@mail.gmail.com>
In-Reply-To: <CAFo99gZOr=1z8J_gNNRLXnKNBEiPCE_G3=ryaN5hAHvewHf0_w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2014 05:01 PM, Rickard Strandqvist wrote:
> Hi
>
> No the rtw_hw_resume23a() is not used anywhere.
> I also do a check of all functions that are not used, but not in the
> drivers/staging, I suspected that these might be under development and
> used in the future.
>
> What do you want to do, who decides?

The original developers of this code do not include any of the Linux 
maintainers. If you see an unused routine, submit a patch to delete it. If a 
maintainer thinks it should be kept, your patch will be NACKed, but that is pnot 
likely.

Larry


