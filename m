Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343Ab3DDAa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 20:30:28 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:63663 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760560Ab3DDAa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 20:30:27 -0400
Message-ID: <1365035424.13853.48.camel@edumazet-glaptop>
Subject: Re: [ 105/124] af_unix: dont send SCM_CREDENTIAL when dest socket
 is NULL
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Sven Joachim <svenjoac@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ding Tianhong <dingtianhong@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@amacapital.net>, Karel Srot <ksrot@redhat.com>
Date: Wed, 03 Apr 2013 17:30:24 -0700
In-Reply-To: <1365034777.13853.46.camel@edumazet-glaptop>
References: <20130402221104.163133110@linuxfoundation.org>
	 <20130402221116.307254752@linuxfoundation.org>
	 <87vc833kpf.fsf@turtle.gmx.de> <87k3ojnosa.fsf@xmission.com>
	 <1365034777.13853.46.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-03 at 17:19 -0700, Eric Dumazet wrote:

> Well, yes, this commit fixes a real bug : We were coalescing two
> messages into a single one, even if the senders were different.

By the way, the 'LSB' test program can be found here :

https://lsbbugs.linuxfoundation.org/attachment.cgi?id=2144



