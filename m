Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab3CLJ2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 05:28:14 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39322 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754780Ab3CLJ1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 05:27:53 -0400
Message-ID: <1363080469.2401.26.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH 12/18] driver: scsi: remove cast for kmalloc/kzalloc
 return value
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 12 Mar 2013 09:27:49 +0000
In-Reply-To: <513EBC2F.6030601@cn.fujitsu.com>
References: <513EB23D.7020303@cn.fujitsu.com>
	 <513EBC2F.6030601@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.6.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-12 at 13:25 +0800, Zhang Yanfei wrote:
> remove cast for kmalloc/kzalloc return value.

I've got to ask why?  Just because void * can be assigned to any pointer
doesn't mean we should religiously eliminate all casts of void *.  If
the driver writer believes there's value making sure of the pointer
type, I'm happy to keep the cast.

James


