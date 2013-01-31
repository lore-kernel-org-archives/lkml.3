Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142Ab3AaWsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:48:25 -0500
Received: from sema.semaphore.gr ([78.46.194.137]:35524 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755414Ab3AaWsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:48:22 -0500
Message-ID: <510AF4B0.7090002@semaphore.gr>
Date: Fri, 01 Feb 2013 00:48:16 +0200
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        David Rientjes <rientjes@google.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: android: Restructure code in lowmemorykiller
References: <510AE2D6.6010101@semaphore.gr> <20130131222511.GA21654@kroah.com>
In-Reply-To: <20130131222511.GA21654@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2013 12:25 AM, Greg Kroah-Hartman wrote:
> Given that no one is working on it, why does it need to be maintained
> easier?  :)

Thanks for your immediate response.
I was thinking to work on this driver. Is it going to be obsolete or 
something?

> Why create a .h file?  Who needs it?  Only create a .h file if some
> other .c file needs something in it, never for just one .c file.
>
> sorry,
>
> greg k-h
>

I will fix it.

Thanks again,
Stratos
