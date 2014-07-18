Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467AbaGRVfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 17:35:22 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:46564 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746AbaGRVfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 17:35:20 -0400
Message-ID: <53C99315.2090003@gmail.com>
Date: Fri, 18 Jul 2014 23:35:17 +0200
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Christoph Lameter <cl@gentwo.org>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>
Subject: Re: WARNING: CPU: 1 PID: 495 at mm/slab_common.c:69 kmem_cache_create+0x1a9/0x330()
References: <53C8DF7F.5060707@gmail.com> <53C8FD95.5020302@gmail.com> <alpine.DEB.2.11.1407180916340.28061@gentwo.org> <53C97DAC.3070305@gmail.com>
In-Reply-To: <53C97DAC.3070305@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.07.2014 22:03, poma wrote:
> On 18.07.2014 16:20, Christoph Lameter wrote:
>> On Fri, 18 Jul 2014, poma wrote:
>>
>>> I guess someone working over the summertime. :)
>>
>> Cache names should not contain blanks. I guess the
>>
>>     WARN_ON(strchr(name, ' '));     /* It confuses parsers */
>>
>> was triggered?
>>
>
> I can only guess also. ;)
>

BTW sorry for the noise. :)


poma


