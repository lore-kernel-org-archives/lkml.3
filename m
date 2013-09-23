Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab3IWOEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 10:04:52 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:60829 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab3IWOEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 10:04:50 -0400
MIME-Version: 1.0
In-Reply-To: <CA+MoWDpwx_2kh9bEARh4D5xzyYhWekAceipf0YN=3a+Q5W4eNQ@mail.gmail.com>
References: <20130923090100.GE6192@mwanda>
	<CA+MoWDpwx_2kh9bEARh4D5xzyYhWekAceipf0YN=3a+Q5W4eNQ@mail.gmail.com>
Date: Mon, 23 Sep 2013 16:04:50 +0200
X-Google-Sender-Auth: eJJAQBSGt10yud1NhvxJ6p9iDho
Message-ID: <CAMuHMdVbjsg5g2or=g9k-W1KFd0HM4SN5uRWyMtZ9P_=aWhadg@mail.gmail.com>
Subject: Re: checkpatch guide for newbies
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 2:46 PM, Peter Senna Tschudin
<peter.senna@gmail.com> wrote:
>> Ask yourself, is the warning message is clear?  Is it needed?  Could a

s/is clear/clear/

>> It's preferred if the operator goes at the end of the first line instead of at
>> the start of the second line:
>> Bad:
>> -       PowerData = (1 << 31) | (0 << 30) | (24 << 24)
>> -                   | BitReverse(w89rf242_txvga_data[i][0], 24);
>> Good:
>> +       PowerData = (1 << 31) | (0 << 30) | (24 << 24) |
>> +                   BitReverse(w89rf242_txvga_data[i][0], 24);
> What is the rule for where to start the second line here?

Either aligned to the equivalent part on the previous line (i.e. "BitReverse" is
aligned with "(1 << 31)"), or one indent step more than the beginning of the
first line (i.e. "BitReverse" is indented by one more TAB tjan "PowerData").

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
