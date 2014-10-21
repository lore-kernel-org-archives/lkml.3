Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008AbaJUUC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 16:02:29 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35444 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569AbaJUUC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 16:02:28 -0400
Message-ID: <5446BBD2.8040306@kernel.dk>
Date: Tue, 21 Oct 2014 14:02:26 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
        "Elliott, Robert (Server Storage)" <Elliott@hp.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] block: remove artifical max_hw_sectors cap
References: <1410044885-14893-1-git-send-email-hch@lst.de> <20141001130822.GA5362@infradead.org> <94D0CD8314A33A4D9D801C0FE68B402958CC7BAB@G4W3202.americas.hpqcorp.net> <20141001211258.GB24820@infradead.org> <20141017131247.GA16538@infradead.org>
In-Reply-To: <20141017131247.GA16538@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2014 07:12 AM, Christoph Hellwig wrote:
> On Wed, Oct 01, 2014 at 02:12:58PM -0700, Christoph Hellwig wrote:
>> On Wed, Oct 01, 2014 at 06:59:34PM +0000, Elliott, Robert (Server Storage) wrote:
>>> One supporting example: A low limit interferes with creation of
>>> full stripe writes for RAID controllers.
>>
>> Yes, both Linux mdraid and parity raids are often crippled by the
>> default.  The mdadm default of 512kb for each chunk combined with
>> the default limit very much guarantees a horrible out of the box
>> experience.
> 
> Jens, can you apply this patch once the 3.19 queue opens?

Yup, lets get it applied.

-- 
Jens Axboe

