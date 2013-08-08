Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422Ab3HHEEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 00:04:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57347 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761Ab3HHEEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 00:04:09 -0400
Message-ID: <52031808.2070907@zytor.com>
Date: Wed, 07 Aug 2013 21:01:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, Borislav Petkov <bp@alien8.de>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Jacob Shin <jacob.shin@amd.com>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH v2] x86, relocs: move ELF relocation handling to C
References: <20130708161517.GA4832@www.outflux.net> <51DAF84A.3070202@gmail.com> <CAGXu5jK--uyNcg3LTRFj2zNQv7gxkHKXvSB-D_FELu9ONrP15A@mail.gmail.com>
In-Reply-To: <CAGXu5jK--uyNcg3LTRFj2zNQv7gxkHKXvSB-D_FELu9ONrP15A@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 06:34 PM, Kees Cook wrote:
> 
> Hi Peter,
> 
> Can this get added to tip?
> 
> Thanks,
> 
> -Kees
> 

Sorry, missed the 7/8 update...

	-hpa


