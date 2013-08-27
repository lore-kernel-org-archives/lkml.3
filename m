Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab3H0OLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 10:11:42 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:59490 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753300Ab3H0OLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 10:11:41 -0400
Message-ID: <521CB384.8070406@mellanox.com>
Date: Tue, 27 Aug 2013 17:11:16 +0300
From: Amir Vadai <amirv@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
CC: Eliezer Tamir <eliezer@tamir.org.il>,
        Willem de Bruijn <willemb@google.com>,
        Eilon Greenstein <eilong@broadcom.com>,
        Eric Wong <normalperson@yhbt.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        Eric Dumazet <erdnetdev@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH RFC net-next] net: epoll support for busy poll
References: <20130821103954.30607.6819.stgit@ladj378.jer.intel.com> <20130822201135.GA4088@dcvr.yhbt.net> <52170E78.1010704@linux.intel.com> <CAPcc5PhQGB195pMsMGOEE8BhZTvfXOf+Fh+3PdPbuOS0t1SULQ@mail.gmail.com> <521AEFC2.9010201@linux.intel.com>
In-Reply-To: <521AEFC2.9010201@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.222.66.109]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/08/2013 09:03, Eliezer Tamir wrote:
> On 26/08/2013 00:30, Amir Vadai wrote:
>> I'm on vacation, will test and have some inputs later this week when I be
>> back.
>>
> Hello Amir,
> 
> Ping me when you get back and I will send you my latest so you can
> play with it.
> 

Hi Eliezer,

You can send the latest version, so I can play with it and get some numbers.

Thanks,
Amir
