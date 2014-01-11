Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbaAKL0t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 06:26:49 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:52483 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaAKL0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 06:26:46 -0500
MIME-Version: 1.0
In-Reply-To: <20140111111931.GV30234@mwanda>
References: <52c9bc8b.ca41420a.775b.ffff98ce@mx.google.com>
	<1389438033-5928-1-git-send-email-monamagarwal123@gmail.com>
	<20140111111931.GV30234@mwanda>
Date: Sat, 11 Jan 2014 16:56:44 +0530
Message-ID: <CAFB2WuU=aGwVM7n1Zy7OSnEaR00ZWyPNXGw9A5MBk1p0+LSKZg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] Staging: lustre: Refactor the function
 interval_erase_color() in /lustre/ldlm/interval_tree.c
From: Monam Agarwal <monamagarwal123@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: gregkh@linuxfoundation.org, Rashika Kheria <rashika.kheria@gmail.com>,
        peter.p.waskiewicz.jr@intel.com, andreas.dilger@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I took n as a flag to decide whether parent->in_left == node is true
or not in the called function.
Should I use some other name for the flag.

On Sat, Jan 11, 2014 at 4:49 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Sat, Jan 11, 2014 at 04:30:33PM +0530, Monam Agarwal wrote:
>> The function interval_erase_color() in lustre/ldlm/interval_tree.c is
>> too long and can be refactored. Most of the statements are same for if
>> and else conditions. I am passing a new variable n based on which the
>> differences are recognised.
>>
>
> "n" stands for number, but what is the it the number of?
>
> regards,
> dan carpenter
>
