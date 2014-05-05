Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424AbaEEEad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 00:30:33 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:51997 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394AbaEEEab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 00:30:31 -0400
MIME-Version: 1.0
X-Originating-IP: [60.248.88.209]
In-Reply-To: <20140502085713.GF4963@mwanda>
References: <1398857429.6930.51.camel@localhost>
	<20140502085713.GF4963@mwanda>
Date: Mon, 5 May 2014 12:30:30 +0800
Message-ID: <CAKiknE-9yQJaZSMSsuuiq+snmbUXbbTBYUdCa1u2_t3s8RCSiA@mail.gmail.com>
Subject: Re: [PATCH v1.0 12/16] arcmsr: revise alloction of second
 dma_coherent_handle for type B adapter
From: =?UTF-8?B?6buD5riF6ZqG?= <ching2048@areca.com.tw>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: James Bottomley <jbottomley@parallels.com>,
        Tomas Henzl <thenzl@redhat.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

This patch is not a bugfix.
It is a simplification and consistency of coding for both adapter type B and D.

Regards,
Ching

2014-05-02 16:57 GMT+08:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Wed, Apr 30, 2014 at 07:30:29PM +0800, ching wrote:
>> From: Ching<ching2048@areca.com.tw>
>>
>> Revise allocation of second dma_coherent_handle for type_B adapter.
>>
>
> Is this a bugfix?  I think it is.  Do you know what the user visible
> effects are?
>
> regards,
> dan carpenter
>
