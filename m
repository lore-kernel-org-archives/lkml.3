Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687Ab3FZH5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 03:57:30 -0400
Received: from intranet.asianux.com ([58.214.24.6]:9014 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab3FZH51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 03:57:27 -0400
X-Spam-Score: -100.8
Message-ID: <51CA9EB3.1070201@asianux.com>
Date: Wed, 26 Jun 2013 15:56:35 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Richard Weinberger <richard@nod.at>, Jeff Dike <jdike@addtoit.com>,
        Arnd Bergmann <arnd@arndb.de>, David Sharp <dhsharp@google.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        uml-user <user-mode-linux-user@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] include/asm-generic/io.h: add 'UML' case just like 'no-MMU'
References: <51CA8AB8.7080504@asianux.com> <51CA900E.9020407@nod.at> <CAMuHMdU-eWL-PtR64pdXw3mpjHxdx7Geym29E5KpATSe5QvBEg@mail.gmail.com>
In-Reply-To: <CAMuHMdU-eWL-PtR64pdXw3mpjHxdx7Geym29E5KpATSe5QvBEg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 03:38 PM, Geert Uytterhoeven wrote:
> On Wed, Jun 26, 2013 at 8:54 AM, Richard Weinberger <richard@nod.at> wrote:
>>> >> -#ifndef CONFIG_MMU
>>> >> +#if !CONFIG_MMU || CONFIG_UML
> FWIW, the above syntax is not correct, it should be
> 
> #if !defined(CONFIG_MMU) || defined(CONFIG_UML)
> 

Oh, really it is.  :-)


Thanks.
-- 
Chen Gang

Asianux Corporation
