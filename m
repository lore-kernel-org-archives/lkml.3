Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751036AbaG1Qs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 12:48:27 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:57766 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaG1QsZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 12:48:25 -0400
MIME-Version: 1.0
In-Reply-To: <53D5C7BB.8050906@daenzer.net>
References: <20140723190230.GH3935@laptop>
	<CA+55aFyM1wqTLK0m4GQJ28f=z0iZE87=xk+1z-vm+PH1_d8nKw@mail.gmail.com>
	<53D064C7.5050807@daenzer.net>
	<CA+55aFyJhqiPv0kQ+51=Ei-zaAO+0JszxtnEyx-Gbto3SE00xw@mail.gmail.com>
	<53D1B1EF.7030603@daenzer.net>
	<20140725035527.GA30108@pg-vmw-gw1>
	<20140725140237.GB32669@home.goodmis.org>
	<CA+55aFzOoJzqJ=4RVPEBfscA8oRdr5Nv7fKx9aXYw2+frkuhwA@mail.gmail.com>
	<CA+55aFyHU4Gwk6ASTuOgh3eFPshkgy1s5zc4p7f01DwrYddFOw@mail.gmail.com>
	<CA+55aFxaXPqyDJv-SNu6Giy3eKCu_SY1wof1NaNnPTbtF9RbXQ@mail.gmail.com>
	<20140726193557.GA21842@x4>
	<CA+55aFyo=HVZGEYNmz9GHqLatFHiJYTviKz_dXjqCv8b_gGxBA@mail.gmail.com>
	<53D5C7BB.8050906@daenzer.net>
Date: Mon, 28 Jul 2014 09:48:24 -0700
X-Google-Sender-Auth: xYEKR4lsKPYxAyBS3qGKCe8ZVUs
Message-ID: <CA+55aFx2k6kjmP3MzB8MsdBeWdi8G3NX72yjLmeEYGa+hQh7qA@mail.gmail.com>
Subject: Re: Random panic in load_balance() with 3.16-rc
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>, Jakub Jelinek <jakub@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Debian GCC Maintainers <debian-gcc@lists.debian.org>,
        Debian Kernel Team <debian-kernel@lists.debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2014 at 8:47 PM, Michel Dänzer <michel@daenzer.net> wrote:
> On 27.07.2014 04:56, Linus Torvalds wrote:
>>
>> Also, Michel - can you try  this patch if you still have your
>> gcc-4.9.0 install, and send me the resulting fair.s file again?
>
> Attached.

The frame setup looks fine to me now (apart from the spilling of a
constant value, but hey, that wasn't _buggy_, that was just stupid).

And I'm assuming everything runs fine too?

                  Linus
