Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab3KVBrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 20:47:42 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:47052 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab3KVBrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 20:47:40 -0500
Message-ID: <528EB834.1050702@gmail.com>
Date: Fri, 22 Nov 2013 09:49:40 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mark Salter <msalter@redhat.com>
CC: a-jacquiot@ti.com, viro@zeniv.linux.org.uk, linux-c6x-dev@linux-c6x.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: c6x: uapi: be sure of "_UAPI" prefix for all guard
 macros
References: <52889AC5.9000806@gmail.com> <1385049781.1966.16.camel@deneb.redhat.com>
In-Reply-To: <1385049781.1966.16.camel@deneb.redhat.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2013 12:03 AM, Mark Salter wrote:
> On Sun, 2013-11-17 at 18:30 +0800, Chen Gang wrote:
>> For all uapi headers, need use "_UAPI" prefix for its guard macro
>> (which will be stripped by "scripts/headers_installer.sh").
>>
>> Also be sure that all files have their guard macros.
>>
>> Also be sure that all "#endif" are followed with correct comments.
>>
>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> 
> Acked-by: Mark Salter <msalter@redhat.com>
> 
> 

Thank you very much!! :-)

Thanks.
-- 
Chen Gang
