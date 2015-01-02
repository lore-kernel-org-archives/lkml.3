Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750841AbbABJWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 04:22:17 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:61685 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbbABJWP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 04:22:15 -0500
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: 8BIT
From: Chen Gang <gang.chen.5i5j@gmail.com>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2] drivers: scsi: megaraid: Add "megaraid_sas_internal.h" for internal shared functions using
Date: Fri, 2 Jan 2015 13:03:29 +0800
Message-Id: <5A7713F0-DDDF-4985-BBDA-66F4D428BAD1@gmail.com>
References: <548DB542.7000400@gmail.com> <20141230124511.GB24088@infradead.org>
Cc: "megaraidlinux@lsi.com" <megaraidlinux@lsi.com>,
        "JBottomley@parallels.com" <JBottomley@parallels.com>,
        Sumit Saxena <sumit.saxena@avagotech.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20141230124511.GB24088@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
X-Mailer: iPad Mail (11D257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Could you provide more detail for it, then I can make patch v3 (or I have no any idea
about it).

Thanks

发自我的 iPad

> 在 2014年12月30日，下午8:45，Christoph Hellwig <hch@infradead.org> 写道：
> 
>> On Mon, Dec 15, 2014 at 12:05:22AM +0800, Chen Gang wrote:
>> For shared inline functions crossed source files, better to let it as
>> "static inline" in a header file. For extern functions, better to
>> declare them in header file.
> 
> 
> This one doesn't apply.
