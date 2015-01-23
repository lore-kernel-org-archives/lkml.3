Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351AbbAWTFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 14:05:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbbAWTFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 14:05:50 -0500
Message-ID: <54C29B82.7090502@redhat.com>
Date: Fri, 23 Jan 2015 20:05:38 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michael Tuexen <tuexen@fh-muenster.de>
CC: Vlad Yasevich <vyasevich@gmail.com>, Sun Paul <paulrbk@gmail.com>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Question on SCTP ABORT chunk is generated when the association_max_retrans
 is reached
References: <CAFXGftKp3=OfjkCVBuR-zM3+uZ42Sk_9i2UjAHBNnbX=hQJwpA@mail.gmail.com> <CAFXGft+fwo=8LJEG7h6uOpGciSo5f_dXjSx3sn67RZZp7jsYHw@mail.gmail.com> <54C23581.9060809@redhat.com> <54C27137.5010405@gmail.com> <54C2807E.8080607@redhat.com> <8BBFBEE6-FA34-4190-BFCB-AB6BEC093774@fh-muenster.de>
In-Reply-To: <8BBFBEE6-FA34-4190-BFCB-AB6BEC093774@fh-muenster.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2015 07:36 PM, Michael Tuexen wrote:
...
> Yepp. It might not reach the peer or it might. If it does it helps
> to keep the states in sync. If it doesn't it sometimes helps in
> analysing tracefiles. In BSD, we also send it. It is not required,
> doesn't harm and is useful in some cases...

Ok, as the TCB is destroyed in any case, should be fine then.

Thanks,
Daniel
