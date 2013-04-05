Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161830Ab3DEODz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 10:03:55 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:33758 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161814Ab3DEODy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 10:03:54 -0400
Message-ID: <515ED9BB.3060506@intel.com>
Date: Fri, 05 Apr 2013 15:03:39 +0100
From: Matt Fleming <matt.fleming@intel.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: "Luck, Tony" <tony.luck@intel.com>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "matthew.garrett@nebula.com" <matthew.garrett@nebula.com>
Subject: Re: [PATCH 1/2] efivars: Check max_size only if it is non-zero.
References: <1365080500-13677-1-git-send-email-richard@nod.at> <3908561D78D1C84285E8C5FCA982C28F1E0987DE@ORSMSX108.amr.corp.intel.com> <515DA677.8050805@nod.at>
In-Reply-To: <515DA677.8050805@nod.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/13 17:12, Richard Weinberger wrote:
> Fair point. I'll add such a printk() to my patch and resend.

Also take a look at FW_BUG.
