Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbaB0Ema (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 23:42:30 -0500
Received: from mailout.micron.com ([137.201.242.129]:53071 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbaB0Em3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 23:42:29 -0500
From: "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
        "Asai Thambi Samymuthu Pattrayasamy (asamymuthupa)" 
	<asamymuthupa@micron.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: mtip32xx blk-mq status?
Thread-Topic: mtip32xx blk-mq status?
Thread-Index: AQHPMylN4UdzMEUVyEOU6piuIPCFcJrIfXiAgAAHX5A=
Date: Thu, 27 Feb 2014 04:42:00 +0000
Message-ID: <80B89753B40C5141A3E2D53FE7A2A8A982C86A74@NTXBOIMBX02.micron.com>
References: <20140226192945.GA26603@infradead.org>
 <530E5859.1080303@kernel.dk>
In-Reply-To: <530E5859.1080303@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.201.88.182]
x-tm-as-product-ver: SMEX-10.0.0.4152-7.000.1014-20534.003
x-tm-as-result: No--54.165600-0.000000-31
x-tm-as-user-approved-sender: Yes
x-tm-as-user-blocked-sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On 2014-02-26 11:29, Christoph Hellwig wrote:
> > Hi all,
> >
> > with blk-mq stabilizing in mainline and Jens using mtip32xx as tje
> major
> > example drivers in the past is there any progress on getting the
> > conversion finished and merged?
> 
> I'll pick up the pieces as soon as I get back and can test again. The
> basic conversion is easy enough, I'll just dust that off. On top of
> that
> I started splitting the issue groups up, since it actually gets you a
> good step further than just the basic conversion.

If you have a public branch for the latter, send it our way.  We can
help with the SRSI testing.
 
> The only problem area I ran into was the special case of the unaligned
> writes.

Yup, it's a painful limitation.  If you need any p420m hardware, let me 
know.

-Sam
