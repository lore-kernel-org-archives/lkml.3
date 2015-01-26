Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbbAZMwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:52:42 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:50546 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674AbbAZMwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:52:39 -0500
Message-ID: <54C6388E.2070504@gmail.com>
Date: Mon, 26 Jan 2015 20:52:30 +0800
From: Simon Guo <wei.guo.simon@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.19.0-rc5 01/03] STAGING: Fix pcl818.c coding style issue:
 code indent should use tabs where possible
References: <20150125092816.GA4076@thunderCat> <54C625A3.4020001@mev.co.uk>
In-Reply-To: <54C625A3.4020001@mev.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian,

At 2015/1/26 19:31, Ian Abbott wrote:
>
> Okay, but this comment block really needs reformatting to use the usual
> block comment style, and with spaces to line up the columns instead of
> tabs so it still looks okay when the " * " is removed from the start of
> each line of the block comment.
>
> Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
>

Thanks for your comments for my patch 1~3. I will rework and resend the 
3 patches.

BR,
Simon
