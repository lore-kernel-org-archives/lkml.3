Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935328AbaGXX2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:28:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34775 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934902AbaGXX2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:28:13 -0400
Message-ID: <53D1967A.3060609@zytor.com>
Date: Thu, 24 Jul 2014 16:27:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH -v5] random: introduce getrandom(2) system call
References: <1406212287-9855-1-git-send-email-tytso@mit.edu> <20140724151814.GE32421@khazad-dum.debian.net> <CALCETrXAA=UzS-pRCo5tKSjSCOP9xfu66BG9QbRefVrovkavhQ@mail.gmail.com> <20140724190206.GL6673@thunk.org> <20140724203019.GA20737@khazad-dum.debian.net> <CALCETrXtNUSCQEZ+SKJ5Br41rnF35kGqStkFuX6dN-3z5hVdmQ@mail.gmail.com>
In-Reply-To: <CALCETrXtNUSCQEZ+SKJ5Br41rnF35kGqStkFuX6dN-3z5hVdmQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2014 01:54 PM, Andy Lutomirski wrote:
> 
> Or that someone writes userspace code that gets -EPERM/-EACCESS on
> getrandom with GRND_RANDOM and falls back to something worse than
> getrandom w/o GRND_RANDOM.
> 

-ENXIO?

	-hpa


