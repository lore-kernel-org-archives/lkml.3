Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964992Ab3GENyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 09:54:25 -0400
Received: from mail-vb0-f48.google.com ([209.85.212.48]:51523 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab3GENyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 09:54:23 -0400
Message-ID: <51D6D004.9050909@redhat.com>
Date: Fri, 05 Jul 2013 15:54:12 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org, tj@kernel.org, msnitzer@redhat.com,
        ksievers@redhat.com, jbottomley@parallels.com, axboe@kernel.dk
Subject: Re: [RFC PATCH 0/4] SG_IO filtering via sysfs and minimal whitelist
References: <1369662622-5959-1-git-send-email-pbonzini__802.478011655872$1369666532$gmane$org@redhat.com> <51CA094C.1080400@redhat.com>
In-Reply-To: <51CA094C.1080400@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 25/06/2013 23:19, Paolo Bonzini ha scritto:
> Il 27/05/2013 15:50, Paolo Bonzini ha scritto:
>>
>> We've been running in circles for nine months now.  Let's restart from
>> the maintainer's suggestion, which was probably dismissed too quickly.
>>
>> This is still not a complete solution, because /dev/sgN does not have
>> access to its queue object.  Still, it can be a base for discussion.
>>
>> If accepted (in a complete form with access to the queue object for
>> non-block devices), this series removes the need to fix the opcode
>> conflicts as far as I'm concerned.  We could just consider that a
>> feature of CONFIG_BLK_DEV_SG_FILTER_MMC.
>>
>> Previously posted at https://lkml.org/lkml/2012/9/25/397 (short thread).
>> Rebased just fine, this one is compile-tested only.
>>
>> Paolo
> 
> RFC didn't get many Cs.

Ping^2.

Paolo
