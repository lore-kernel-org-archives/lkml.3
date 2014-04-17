Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617AbaDQBMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 21:12:46 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:61211 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbaDQBMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 21:12:44 -0400
Message-ID: <534F2A88.8050408@gmail.com>
Date: Wed, 16 Apr 2014 18:12:40 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [DRIVER CORE] drivers/base/dd.c incorrect pr_debug() parameters
References: <534F1C6E.7010606@gmail.com> <1397695738.4603.2.camel@joe-AO725>
In-Reply-To: <1397695738.4603.2.camel@joe-AO725>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/16/2014 5:48 PM, Joe Perches wrote:
> On Wed, 2014-04-16 at 17:12 -0700, Frank Rowand wrote:
>> pr_debug() parameters are reverse order of format string
> 
> Another way to do this might be to change all the
> printks/pr_debugs to dev_<level>

Yes, but if that is done, one may as well do all of drivers/base/*.c
and drivers/base/*/*.c

I was only trying to fix incorrectly reported information from one
pr_debug().  If someone else want to do a big conversion, they are
free to.  :-)

> 
> Something like:
> ---
>  drivers/base/dd.c | 35 +++++++++++++++++------------------
>  1 file changed, 17 insertions(+), 18 deletions(-)
> 
< snip >
