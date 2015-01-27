Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241AbbA0Sd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:33:59 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:42564 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbbA0Sd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:33:58 -0500
Message-ID: <54C7DA10.3040209@ahsoftware.de>
Date: Tue, 27 Jan 2015 19:33:52 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Borislav Petkov <bp@alien8.de>, Richard Weinberger <richard@nod.at>,
        linux-mmc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] mmc: print message if a card supports secure erase/trim
References: <1422359304-30321-1-git-send-email-holler@ahsoftware.de>	<CAFLxGvyuE8odPdNSD1PTccyBXFm=JO=ooikUOJfz41aFpsUAJg@mail.gmail.com>	<54C77E69.7050600@ahsoftware.de>	<20150127120855.GA9254@pd.tnic>	<54C7816A.8050800@ahsoftware.de>	<54C78524.3070901@nod.at>	<54C7881F.6020501@ahsoftware.de>	<20150127142120.GA3351@pd.tnic>	<54C7C2EC.7010605@ahsoftware.de>	<20150127172415.GC25043@home.goodmis.org>	<54C7CD1C.1060601@ahsoftware.de>	<20150127124817.608db508@gandalf.local.home>	<54C7D549.3070705@ahsoftware.de> <20150127132148.365ef397@gandalf.local.home>
In-Reply-To: <20150127132148.365ef397@gandalf.local.home>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.01.2015 um 19:21 schrieb Steven Rostedt:

> You want to add a way to tell a property of a device. That is *exactly*
> what sysfs was made for. Not dmesg.

Err, dmesg existed long before sysfs.

Anyway, it's ok. You're all right and I should request project 
sponsoring for offering a simple piece of (imho) interesting information.

Happy frameworking and sorry for disturbing.

Alexander Holler
