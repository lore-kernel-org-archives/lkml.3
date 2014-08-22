Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbaHVPd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 11:33:29 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:58361 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756482AbaHVPd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 11:33:27 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Remove various orphaned header files
Organization: D03
References: <1403630855-29186-1-git-send-email-linux@rasmusvillemoes.dk>
	<1403631263.29061.17.camel@joe-AO725>
X-Hashcash: 1:20:140822:gregkh@linuxfoundation.org::USR0QE6+LUTU9LI3:000000000000000000000000000000000000EnI
X-Hashcash: 1:20:140822:kernel-janitors@vger.kernel.org::oX2dD8wUnADo4Hqz:0000000000000000000000000000000vGg
X-Hashcash: 1:20:140822:linux-kernel@vger.kernel.org::l2nBxeFVivynAJ6Q:0000000000000000000000000000000001eZm
X-Hashcash: 1:20:140822:joe@perches.com::SQTZM+gqiU8GPio8:007xOF
Date: Fri, 22 Aug 2014 17:33:24 +0200
In-Reply-To: <1403631263.29061.17.camel@joe-AO725> (Joe Perches's message of
	"Tue, 24 Jun 2014 10:34:23 -0700")
Message-ID: <8761hksfnf.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> On Tue, 2014-06-24 at 19:27 +0200, Rasmus Villemoes wrote:
>> AFAICT, these headers are not used anywhere, and are just accidental
>> leftovers from past cleanups.
>
> Thanks.

Did anyone pick these [1] up? All six files still seem to be present.

Thanks,
Rasmus

[1]
http://thread.gmane.org/gmane.linux.kernel.janitors/30940/focus=1732006
