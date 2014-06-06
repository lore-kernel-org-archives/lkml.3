Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaFFKrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 06:47:15 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:36484 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbaFFKrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 06:47:13 -0400
Message-ID: <53919C2B.6080606@suse.cz>
Date: Fri, 06 Jun 2014 12:47:07 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        xen-devel@lists.xenproject.org, felipe.franciosi@citrix.com,
        roger.pau@citrix.com, jerry.snitselaar@oracle.com, axboe@kernel.dk,
        vkuznets@redhat.com
Subject: Re: Backport request to stable of two performance related fixes for
 xen-blkfront (3.13 fixes to earlier trees)
References: <20140514191122.GA7659@phenom.dumpdata.com> <20140604054848.GA20895@kroah.com>
In-Reply-To: <20140604054848.GA20895@kroah.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 07:48 AM, Greg KH wrote:
> On Wed, May 14, 2014 at 03:11:22PM -0400, Konrad Rzeszutek Wilk wrote:
>> Hey Greg
>>
>> This email is in regards to backporting two patches to stable that
>> fall under the 'performance' rule:
>>
>>  bfe11d6de1c416cea4f3f0f35f864162063ce3fa
>>  fbe363c476afe8ec992d3baf682670a4bd1b6ce6
> 
> Now queued up, thanks.

AFAIU, they introduce a performance regression.

Vitaly?

-- 
js
suse labs
