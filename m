Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab3L0Mfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 07:35:36 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:64589 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab3L0Mfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 07:35:33 -0500
Message-ID: <52BD7410.4040207@landley.net>
Date: Fri, 27 Dec 2013 06:35:28 -0600
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, Xishi Qiu <qiuxishi@huawei.com>
CC: Andrew Morton <akpm@linux-foundation.org>, vegardno@ifi.uio.no,
        Pekka Enberg <penberg@kernel.org>, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] doc/kmemcheck: add kmemcheck to kernel-parameters.txt
References: <52BBA18F.4080102@huawei.com> <20131227021314.GA25685@kroah.com>
In-Reply-To: <20131227021314.GA25685@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/13 20:13, Greg KH wrote:
> On Thu, Dec 26, 2013 at 11:25:03AM +0800, Xishi Qiu wrote:
>> Add kmemcheck to Documentation/kernel-parameters.txt.
>>
>> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
>> ---
>>   Documentation/kernel-parameters.txt |    7 +++++++
>>   1 files changed, 7 insertions(+), 0 deletions(-)
>
>
> <formletter>
>
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> for how to do this properly.
>
> </formletter>

In general, I doubt standalone documentation fixes are really -stable 
material. (With the possible exception of "make htmldocs" build breaks.)

Rob
