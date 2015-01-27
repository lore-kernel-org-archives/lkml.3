Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601AbbA0SMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:12:53 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41399 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932567AbbA0SMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:12:51 -0500
Date: Tue, 27 Jan 2015 19:12:38 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Arend van Spriel <arend@broadcom.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Richard Weinberger <richard@nod.at>, linux-mmc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] mmc: print message if a card supports secure erase/trim
Message-ID: <20150127181238.GD3351@pd.tnic>
References: <20150127120855.GA9254@pd.tnic>
 <54C7816A.8050800@ahsoftware.de>
 <54C78524.3070901@nod.at>
 <54C7881F.6020501@ahsoftware.de>
 <20150127142120.GA3351@pd.tnic>
 <54C7C2EC.7010605@ahsoftware.de>
 <20150127172415.GC25043@home.goodmis.org>
 <54C7CD1C.1060601@ahsoftware.de>
 <54C7D08E.8030309@broadcom.com>
 <54C7D31D.6090109@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54C7D31D.6090109@ahsoftware.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 07:04:13PM +0100, Alexander Holler wrote:
> dmesg | grep -i mmc (or whatever is of interest)

And what happens if someone has done "dmesg -c" before you?

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
