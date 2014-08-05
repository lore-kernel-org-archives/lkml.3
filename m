Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbaHEQah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 12:30:37 -0400
Received: from smtp.pobox.com ([208.72.237.35]:55253 "EHLO smtp.pobox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276AbaHEQag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 12:30:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=rfkyINnjn/jKUPUkwLQhIixmVJNzPcHk
	hyIGHqCnHi5G8uA1xIBuc53KqfMiEuLJHJOvUI9NkVjtMhhHE8pDdEngbEnZhTU/
	dQZdRt6KNds/RS0abA6yDl2a7MpLdmV0gN/AmnkxWflfqa5d2bsaMhkUg75+algy
	dtBTJKQ/HPA=
From: Junio C Hamano <gitster@pobox.com>
To: Ramsay Jones <ramsay@ramsay1.demon.co.uk>
Cc: git@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Git v2.1.0-rc1
References: <xmqqy4v3q43r.fsf@gitster.dls.corp.google.com>
	<53E01A3D.8070504@ramsay1.demon.co.uk>
Date: Tue, 05 Aug 2014 09:30:24 -0700
In-Reply-To: <53E01A3D.8070504@ramsay1.demon.co.uk> (Ramsay Jones's message of
	"Tue, 05 Aug 2014 00:41:49 +0100")
Message-ID: <xmqqtx5qq4pr.fsf@gitster.dls.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: CECD6D2C-1CBD-11E4-9B1D-9903E9FBB39C-77302942!pb-smtp0.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ramsay Jones <ramsay@ramsay1.demon.co.uk> writes:

> On 04/08/14 23:31, Junio C Hamano wrote:
>> 
>>  * The leaf function to check validity of a refname format has been
>>    micro-optimized, using SSE2 instructions when available.  A few
>>    breakages during its development have been caught and fixed already
>>    but there might remain some more still; please test and report if
>>    you find any.
>
> This has been removed.

Thanks for a reminder.  Will drop.
