Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab3KATEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 15:04:46 -0400
Received: from mail.tpi.com ([74.45.170.26]:41357 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239Ab3KATEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 15:04:45 -0400
Message-ID: <5273FB4C.5010002@tpi.com>
Date: Fri, 01 Nov 2013 12:04:44 -0700
From: Tim Gardner <timg@tpi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Steve French <smfrench@gmail.com>
CC: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>, Jeff Layton <jlayton@redhat.com>,
        Steve French <sfrench@samba.org>
Subject: Re: [PATCH linux-next V2] cifs: Make big endian multiplex ID sequences
 monotonic on the wire
References: <1381941162-72831-1-git-send-email-timg@tpi.com> <CAH2r5mt5kBDR1oZfDNVu+bd7-jf=zQ6tBm2YjKXKBwdYE+YG=w@mail.gmail.com>
In-Reply-To: <CAH2r5mt5kBDR1oZfDNVu+bd7-jf=zQ6tBm2YjKXKBwdYE+YG=w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2013 11:50 AM, Steve French wrote:
> This has a couple of obvious endian errors.  I will correct your patch
> and remerge into cifs-2.6.git for-next
> 
> Please always remember to run endian checks against cifs builds when
> submitting a patch (and make sure sparse is installed)
> 
> e.g.
> 
> make C=1 M=fs/cifs modules CF=-D__CHECK_ENDIAN__
> 

Didn't know about __CHECK_ENDIAN__, but will do so in the future. Your
changes look fine.

rtg
-- 
Tim Gardner timg@tpi.com www.tpi.com
OR 503-601-0234 x102 MT 406-443-5357
