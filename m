Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbaDSQhd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 12:37:33 -0400
Received: from mail-yk0-f171.google.com ([209.85.160.171]:64502 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaDSQh2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 12:37:28 -0400
MIME-Version: 1.0
In-Reply-To: <20140419161552.GB27776@amd.pavel.ucw.cz>
References: <CAGG-pURwpGGFyCp-htffegnVhf1VwAke1XPrC+GirXKy-HhqJA@mail.gmail.com>
	<20140419161552.GB27776@amd.pavel.ucw.cz>
Date: Sat, 19 Apr 2014 13:37:27 -0300
Message-ID: <CAGG-pUQ5+dv566KZK2hbQENXSEPaY5k5fapgnLUE0jTv1ihPMg@mail.gmail.com>
Subject: Re: [Kernel-BR] Re: [RFC] Only a.out QMAGIC format is working
From: =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
To: kernel-br <kernel-br@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "open list:FILESYSTEMS (VFS...), linux-kernel@vger.kernel.org (open
	list)" <linux-fsdevel@vger.kernel.org>,
        kernelnewbies <Kernelnewbies@kernelnewbies.org>, jikos@jikos.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel,

Thank you.

Maintainers, is there some chance to fix it or a.out is really doomed?


2014-04-19 13:15 GMT-03:00 Pavel Machek <pavel@ucw.cz>:
> Hi!
>
>> I was researching about old binary formats and did some tests.
>> Meantime, I was able to run sucessfully only the QMAGIC format.
>> Nonetheless, the OMAGIC, NMAGIC and ZMAGIC didn't work anymore.
>
> Some time ago, I ran into similar problem, and turning off userspace
> randomization was neccessary... Jiri Kosina might remember details.
>
>                                                                         Pavel
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>
> --
> Você está recebendo esta mensagem porque se inscreveu no grupo "Kernel Brasil" dos Grupos do Google.
> Para cancelar inscrição nesse grupo e parar de receber e-mails dele, envie um e-mail para kernel-br+unsubscribe@googlegroups.com.
> Para postar neste grupo, envie um e-mail para kernel-br@googlegroups.com.
> Para ver esta discussão na web, acesse https://groups.google.com/d/msgid/kernel-br/20140419161552.GB27776%40amd.pavel.ucw.cz.
> Para obter mais opções, acesse https://groups.google.com/d/optout.



-- 
Regards,

Geyslan G. Bem
hackingbits.com
