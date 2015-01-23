Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbbAWKZJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 05:25:09 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:40020 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850AbbAWKZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 05:25:04 -0500
MIME-Version: 1.0
In-Reply-To: <CAFXGftKp3=OfjkCVBuR-zM3+uZ42Sk_9i2UjAHBNnbX=hQJwpA@mail.gmail.com>
References: <CAFXGftKp3=OfjkCVBuR-zM3+uZ42Sk_9i2UjAHBNnbX=hQJwpA@mail.gmail.com>
Date: Fri, 23 Jan 2015 18:25:01 +0800
Message-ID: <CAFXGft+fwo=8LJEG7h6uOpGciSo5f_dXjSx3sn67RZZp7jsYHw@mail.gmail.com>
Subject: Fwd: Question on SCTP ABORT chunk is generated when the
 association_max_retrans is reached
From: Sun Paul <paulrbk@gmail.com>
To: linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I would like to check the behave in LKSCTP.

we are running DIAMETER message over SCTP, and we have set the
parameter "net.sctp.association_max_retrans = 4" in the LinuxOS.

We noticed that when remote peer have retry to send the same request
for 4 times, the LKSCTP will initiate an ABORT chunk with reason
"association exceeded its max_retrans count".

We would like to know whether this is the correct behavior? is there
any other option that we can alter in order to avoid the ABORT chunk
being sent?

Thanks

PS
