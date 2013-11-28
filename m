Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674Ab3K1CPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 21:15:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756631Ab3K1CPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 21:15:42 -0500
References: <87bo1bnxhi.fsf@redhat.com> <20131127114440.GF18170@console-pimps.org>
User-agent: mu4e 0.9.9.6pre2; emacs 24.3.1
From: Madper Xie <cxie@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Madper Xie <cxie@redhat.com>,
        "'linux-kernel\@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "linux-efi\@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "matt.fleming\@intel.com" <matt.fleming@intel.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "richard\@nod.at" <richard@nod.at>, Tony Luck <tony.luck@gmail.com>
Subject: Re: [PATCH v2] efi-pstore: Make efi-pstore return a unique id
In-reply-to: <20131127114440.GF18170@console-pimps.org>
Date: Thu, 28 Nov 2013 10:15:18 +0800
Message-ID: <87vbzdb7bd.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


matt@console-pimps.org writes:

> On Sat, 23 Nov, at 07:55:37PM, Madper Xie wrote:
>> 
>> Pstore fs expects that backends provide a uniqued id which could avoid
>> pstore making entries as duplication or denominating entries the same
>> name. So I combine the timestamp, part and count into id.
>> 
>> Signed-off-by: Madper Xie <cxie@redhat.com>
>> ---
>>  drivers/firmware/efi/efi-pstore.c | 19 +++++++++++++------
>>  1 file changed, 13 insertions(+), 6 deletions(-)
>
> Thanks unless anyone complains, I'm going to apply this.
>
> Does this need to be tagged for stable?
Since it fix a real issue, my answer is "Yes".
