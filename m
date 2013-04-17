Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816Ab3DQHci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 03:32:38 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754961Ab3DQHch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 03:32:37 -0400
Message-ID: <516E500E.3020909@nod.at>
Date: Wed, 17 Apr 2013 09:32:30 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: matt.fleming@intel.com, cbouatmailru@gmail.com, ccross@android.com,
        keescook@chromium.org, tony.luck@intel.com, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, matthew.garrett@nebula.com
Subject: Re: [PATCH] x86,efi: Implement efi_no_storage_paranoia parameter
References: <1366153253-28572-1-git-send-email-richard@nod.at> <alpine.LRH.2.00.1304170116060.8789@twin.jikos.cz>
In-Reply-To: <alpine.LRH.2.00.1304170116060.8789@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 17.04.2013 01:16, schrieb Jiri Kosina:
> On Wed, 17 Apr 2013, Richard Weinberger wrote:
>> +static bool efi_no_storage_paranoia;
>> +EXPORT_SYMBOL_GPL(efi_no_storage_paranoia);
>
> Is there any particular reason to export this symbol?

I saw that the other parameters in that file are exported too
and other (efi) drivers may also be interested in that symbol.
So I thought it is a good idea to export it too.

Thanks,
//richard
