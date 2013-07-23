Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934910Ab3GWWbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:31:00 -0400
Received: from mx12.netapp.com ([216.240.18.77]:11753 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934308Ab3GWWa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:30:58 -0400
X-IronPort-AV: E=Sophos;i="4.89,731,1367996400"; 
   d="scan'208";a="75552717"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>
Subject: Re: [ 068/103] SUNRPC: fix races on PipeFS UMOUNT notifications
Thread-Topic: [ 068/103] SUNRPC: fix races on PipeFS UMOUNT notifications
Thread-Index: AQHOh/PZDBq9O3XE0Ues8feEZdTq0plzTgkA
Date: Tue, 23 Jul 2013 22:30:57 +0000
Message-ID: <1374618656.12943.20.camel@leira.trondhjem.org>
References: <20130723220418.532514378@linuxfoundation.org>
	 <20130723220426.853989725@linuxfoundation.org>
In-Reply-To: <20130723220426.853989725@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.51]
Content-Type: text/plain; charset="utf-8"
Content-ID: <60E4C2F0230DA441A7E12E6677C8A9C5@hq.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6NMVERm023050

On Tue, 2013-07-23 at 15:26 -0700, Greg Kroah-Hartman wrote:
> 3.10-stable review patch.  If anyone has any objections, please let me know.
> 

Again, please drop this patch and 67/103 for now. We'll get back to
whether or not this should be stable material later.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
