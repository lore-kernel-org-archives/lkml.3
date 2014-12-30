Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbaL3Q6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 11:58:31 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33210 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaL3Q6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 11:58:30 -0500
MIME-Version: 1.0
In-Reply-To: <20141230154808.GA21238@nazgul.tnic>
References: <1419946102-17175-1-git-send-email-kuleshovmail@gmail.com>
	<20141230154808.GA21238@nazgul.tnic>
Date: Tue, 30 Dec 2014 22:58:29 +0600
Message-ID: <CANCZXo4m-X0ZJG2oU-YABYxTJ6-0+B8eR-UONfcXatzJA=S=Mg@mail.gmail.com>
Subject: Re: [PATCH v2] x86/boot/early_serial_console: Remove unnecessary check
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do i need to send patch v3 to separate mail thread or add to it?

2014-12-30 21:48 GMT+06:00 Borislav Petkov <bp@alien8.de>:
> On Tue, Dec 30, 2014 at 07:28:22PM +0600, Alexander Kuleshov wrote:
>> There is already the same check before.
>>
>> Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
>> ---
>>  arch/x86/boot/early_serial_console.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/boot/early_serial_console.c b/arch/x86/boot/early_serial_console.c
>> index 5df2869..62abcc8 100644
>> --- a/arch/x86/boot/early_serial_console.c
>> +++ b/arch/x86/boot/early_serial_console.c
>> @@ -74,8 +74,7 @@ static void parse_earlyprintk(void)
>>                       static const int bases[] = { 0x3f8, 0x2f8 };
>>                       int idx = 0;
>>
>> -                     if (!strncmp(arg + pos, "ttyS", 4))
>> -                             pos += 4;
>
> You might need a comment to explain the advancing of pos to people who
> look at this in the future, i.e. something like
>
>                         /* += strlen("ttyS"); */
>                         pos += 4;
>>
>>                       if (arg[pos++] == '1')
>>                               idx = 1;
>
> --
> Regards/Gruss,
>     Boris.
> --



-- 
_________________________
0xAX
