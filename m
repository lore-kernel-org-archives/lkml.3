Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874Ab3DYPmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 11:42:54 -0400
Received: from mx12.netapp.com ([216.240.18.77]:16023 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755921Ab3DYPmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 11:42:53 -0400
X-IronPort-AV: E=Sophos;i="4.87,551,1363158000"; 
   d="scan'208";a="44837644"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: "Matt W. Benjamin" <matt@linuxbox.com>
CC: David Wysochanski <dwysocha@redhat.com>,
        Dave Chiluk <chiluk@canonical.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bfields@fieldses.org" <bfields@fieldses.org>
Subject: RE: [PATCH] NFSv4: Use exponential backoff delay for Ni
Thread-Topic: [PATCH] NFSv4: Use exponential backoff delay for Ni
Thread-Index: AQHOQcmM6v2BE2HMzk2/QxEEFn1gq5jnE3gw
Date: Thu, 25 Apr 2013 15:42:50 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA9287414AA@SACEXCMBX04-PRD.hq.netapp.com>
References: <1366899034.6812.4.camel@leira.trondhjem.org>
 <916743278.65.1366903701195.JavaMail.root@thunderbeast.private.linuxbox.com>
In-Reply-To: <916743278.65.1366903701195.JavaMail.root@thunderbeast.private.linuxbox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.51]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3PFh1Hu029507

It's legal, but dumb...

> -----Original Message-----
> From: Matt W. Benjamin [mailto:matt@linuxbox.com]
> Sent: Thursday, April 25, 2013 11:28 AM
> To: Myklebust, Trond
> Cc: David Wysochanski; Dave Chiluk; linux-nfs@vger.kernel.org; linux-
> kernel@vger.kernel.org; bfields@fieldses.org
> Subject: Re: [PATCH] NFSv4: Use exponential backoff delay for Ni
> 
> Hi,
> 
> Just to clarify, the IBM delay behavior is not legal?
> 
> Matt
> 
> ----- "Trond Myklebust" <Trond.Myklebust@netapp.com> wrote:
> 
> >
> > OK, then. Now all I need is actual motivation for changing the
> > existing code other than handwaving arguments about "polling is better
> > than flat waits".
> > What actual use cases are impacting us now, other than the AIX design
> > decision to force CLOSE to retry at least once before succeeding?
> >
> 
> 
> --
> Matt Benjamin
> The Linux Box
> 206 South Fifth Ave. Suite 150
> Ann Arbor, MI  48104
> 
> http://linuxbox.com
> 
> tel.  734-761-4689
> fax.  734-769-8938
> cel.  734-216-5309
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
