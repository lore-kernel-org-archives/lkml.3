Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760586AbaGYVhO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 17:37:14 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33202 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbaGYVhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 17:37:11 -0400
Date: Fri, 25 Jul 2014 22:35:50 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Julien Tinnes <jln@google.com>, David Drysdale <drysdale@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Paolo Bonzini <pbonzini@redhat.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Moore <paul@paul-moore.com>,
        James Morris <james.l.morris@oracle.com>,
        Linux API <linux-api@vger.kernel.org>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        linux-crypto@vger.kernel.org
Subject: Re: General flags to turn things off (getrandom, pid lookup, etc)
Message-ID: <20140725223550.3153f436@alan.etchedpixels.co.uk>
In-Reply-To: <CALCETrWGvBfrX1W5XaFgJZhKHLf+oac9YrwPR3ppK=deQtu5hA@mail.gmail.com>
References: <CALCETrWGvBfrX1W5XaFgJZhKHLf+oac9YrwPR3ppK=deQtu5hA@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2014 11:30:48 -0700
Andy Lutomirski <luto@amacapital.net> wrote:

> [new thread because this sort of combines two threads]
> 
> There is recent interest in having a way to turn generally-available
> kernel features off.  Maybe we should add a good one so we can stop
> bikeshedding and avoid proliferating dumb interfaces.

We sort of have one. It's called capable(). Just needs extending to cover
anything else you care about, and probably all the numeric constants
replacing with textual names.

Alan
