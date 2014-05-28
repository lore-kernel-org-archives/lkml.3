Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbaE1UuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:50:20 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:54393 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbaE1UuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 16:50:17 -0400
Message-ID: <53864BFA.6070103@free.fr>
Date: Wed, 28 May 2014 22:50:02 +0200
From: mathieu souchaud <mattieu.souchaud@free.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: tony.luck@intel.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v3] x86/mce: Improve mcheck_init_device() error handling
References: <1401261157-1165-1-git-send-email-mattieu.souchaud@free.fr> <20140528095227.GA17196@pd.tnic>
In-Reply-To: <20140528095227.GA17196@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks too, you helped me a lot.

I can do more work, if it's not too difficult for me.

Mathieu

Le 28/05/2014 11:52, Borislav Petkov a écrit :
> On Wed, May 28, 2014 at 09:12:37AM +0200, Mathieu Souchaud wrote:
>> Check return code of every function called by mcheck_init_device().
>>
>> Signed-off-by: Mathieu Souchaud <mattieu.souchaud@free.fr>
> Applied, thanks!
>
> I'll queue it for 3.17 though since we're very close to the 3.16 merge
> window and this patch hasn't had any linux-next time.
>
> Thanks for your good work, let me know if you want to do more around mce.
>
> :-)
>

