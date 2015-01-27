Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759116AbbA0SEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:04:24 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:40937 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759092AbbA0SEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:04:20 -0500
Message-ID: <54C7D31D.6090109@ahsoftware.de>
Date: Tue, 27 Jan 2015 19:04:13 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Borislav Petkov <bp@alien8.de>,
        Richard Weinberger <richard@nod.at>, linux-mmc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] mmc: print message if a card supports secure erase/trim
References: <1422359304-30321-1-git-send-email-holler@ahsoftware.de> <CAFLxGvyuE8odPdNSD1PTccyBXFm=JO=ooikUOJfz41aFpsUAJg@mail.gmail.com> <54C77E69.7050600@ahsoftware.de> <20150127120855.GA9254@pd.tnic> <54C7816A.8050800@ahsoftware.de> <54C78524.3070901@nod.at> <54C7881F.6020501@ahsoftware.de> <20150127142120.GA3351@pd.tnic> <54C7C2EC.7010605@ahsoftware.de> <20150127172415.GC25043@home.goodmis.org> <54C7CD1C.1060601@ahsoftware.de> <54C7D08E.8030309@broadcom.com>
In-Reply-To: <54C7D08E.8030309@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.01.2015 um 18:53 schrieb Arend van Spriel:

> Ever used rgrep or grep -R. Anyway, if this is you use-case what about
> the gazillion other pieces of info in the kernel. When moving in that
> direction you can be sure dmesg will flush out.

Sorry, never heard about that -R and wasn't aware that the kernel does a 
lot of things. ;)

I don't want that ftrace stuff appears in dmesg, but I like to do

dmesg | grep -i mmc (or whatever is of interest)

instead of

grep -Rsi mmc /sys/<a hundred tabs to search a matching direcory> or 
something like

find /sys -iname '*mmc*' -exec <more silly complications> \;

Alexander Holler
