Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab3FFIjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 04:39:21 -0400
Received: from intranet.asianux.com ([58.214.24.6]:9863 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab3FFIjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 04:39:16 -0400
X-Spam-Score: -100.8
Message-ID: <51B04A80.7050001@asianux.com>
Date: Thu, 06 Jun 2013 16:38:24 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: schmitz <schmitz@biophys.uni-duesseldorf.de>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, Greg Ungerer <gerg@uclinux.org>,
        schmitz@debian.org, Sam Ravnborg <sam@ravnborg.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Thorsten Glaser <tg@mirbsd.de>
Subject: Re: [PATCH] arch: m68k: include: asm: the 3rd parameter of 'insl'
 and 'outsl' need '<< 2'
References: <51A71E49.1000707@asianux.com> <CAMuHMdUz8o4d=RiAMW8-pCrnZyfoH9EETVqjcb7E1GqCgYmQ7g@mail.gmail.com> <51A93FA0.1050203@biophys.uni-duesseldorf.de> <51A94281.7050708@biophys.uni-duesseldorf.de> <51AC6472.3060606@asianux.com> <CAMuHMdVLA_zgeGxTTzfXnBYZiihH3w+LLcW0cRzVk_dvkFojgg@mail.gmail.com> <51AE87DF.5000301@asianux.com> <51AEE7C0.9060206@biophys.uni-duesseldorf.de>
In-Reply-To: <51AEE7C0.9060206@biophys.uni-duesseldorf.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2013 03:24 PM, schmitz wrote:
>> It seems already has another related patch for it, and it is just
>> applying.
>>
>> So need I send it again ?
>>
>>   
> I think Thorsten submitted a patch to that effect? If so, yours should
> not be necessary.

OK, thanks.

And also thank Geert.

-- 
Chen Gang

Asianux Corporation
