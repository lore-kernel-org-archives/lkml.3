Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab3CSOvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:51:11 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44706 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756184Ab3CSOvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:51:08 -0400
X-Sasl-enc: uqCx+QTTNOr/mDhdvRtljIgOF+gea25YKxN8mNMfj0m+ 1363704667
Message-ID: <51487B59.6010607@ladisch.de>
Date: Tue, 19 Mar 2013 15:51:05 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hpet, allow user controlled mmap for user processes
References: <51444171.1080905@ladisch.de> <1363609488-25250-1-git-send-email-prarit@redhat.com> <5148171D.10807@ladisch.de> <5148747C.9020803@redhat.com>
In-Reply-To: <5148747C.9020803@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prarit Bhargava wrote:
> On 03/19/2013 03:43 AM, Clemens Ladisch wrote:
>> Prarit Bhargava wrote:
>>> +	int "Enable HPET MMAP access by default"
>>> +	default 0
>>
>> This breaks backwards compatibility.
>
> Does backwards compatibility matter for something like?  I have no problem
> setting it to 1 but I'm more curious from a general kernel point of view.

When somebody updates from some old kernel where HPET mmap was
explicitly enabled, this default value will now disable it.  The
default behaviour should always be to be compatible with older
kernels.


Regards,
Clemens
