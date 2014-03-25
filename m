Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777AbaCYPiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 11:38:22 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:44353 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbaCYPiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 11:38:20 -0400
Message-ID: <5331B0F9.9000403@cogentembedded.com>
Date: Tue, 25 Mar 2014 19:38:17 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Shuah Khan <shuah.kh@samsung.com>, gregkh@linuxfoundation.org,
        john@jjdev.com, ced@ryick.net
CC: linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCH] staging/usbip: fix store_attach() sscanf return value
 check
References: <1395702729-3281-1-git-send-email-shuah.kh@samsung.com>
In-Reply-To: <1395702729-3281-1-git-send-email-shuah.kh@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 03/25/2014 02:12 AM, Shuah Khan wrote:

> Fix commit - 88fa1ebfa21b5deaaad2dc88ecd9f6af91796cf7

    Please also specify that commit's summary line in parens. Also, there's 
now an established format for such things:

Fixes: <12-digit SHA ID> ("<summary line>")

    You can place such line before your signoff line.

> This commit added return value check for sscanf() that parses the
> input buffer for four input items. However, the return value check
> is incorrect, as it checks for one input item instead of four which
> is what it is expecting in the input buffer. As a result, sscanf()
> will always fail even when the input buffer is correct.

> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>

WBR, Sergei

