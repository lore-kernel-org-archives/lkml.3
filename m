Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab3FXVRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 17:17:21 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:26509 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab3FXVRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 17:17:20 -0400
Message-ID: <51C8B75C.8040606@oracle.com>
Date: Mon, 24 Jun 2013 15:17:16 -0600
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v2 0/2] scsi: Port buslogic driver to 64 bits
References: <cover.1368754558.git.khalid.aziz@oracle.com> <1372107313.2013.81.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1372107313.2013.81.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 02:55 PM, James Bottomley wrote:
> On Mon, 2013-06-24 at 14:25 -0600, Khalid Aziz wrote:
>> This patchset ports buslogic driver to 64-bit.
>
> OK, thought long and hard about this., I'll take it on the proviso that
> you're the new buslogic maintainer.  The reason being that without
> someone to sort through any bug reports, the only option I have on a bug
> which is in the rework but not the original would be to revert to the
> original.


James,

Understood. I am ok with this.

--
Khalid
