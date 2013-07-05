Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab3GEAxf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 20:53:35 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:41646 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab3GEAxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 20:53:31 -0400
Message-ID: <51D618C9.4080103@gmail.com>
Date: Fri, 05 Jul 2013 08:52:25 +0800
From: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Arnd Bergmann <arnd@arndb.de>, Chen Gang <gang.chen@asianux.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Richard Weinberger <richard@nod.at>, Jeff Dike <jdike@addtoit.com>,
        David Sharp <dhsharp@google.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        Ingo Molnar <mingo@kernel.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        uml-user <user-mode-linux-user@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <trivial@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] include/asm-generic/io.h: add dummy fuctions to support
 'COMPILE_TEST' in 'asm-generic'.
References: <20130704011221.GA11230@kroah.com> <20130704061204.GA12148@kroah.com> <51D517A7.6030908@asianux.com> <201307041125.15083.arnd@arndb.de> <51D60D53.7050405@gmail.com> <20130705001239.GA20869@kroah.com>
In-Reply-To: <20130705001239.GA20869@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2013 08:12 AM, Greg KH wrote:
> I'm done with this thread, it's madness..

Yeah, especially discussing with 'mad users' (e.g. allmodconfig,
randconfig, and me too).  ;-)


Thanks.
-- 
Chen Gang
