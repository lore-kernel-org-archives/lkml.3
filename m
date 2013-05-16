Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab3EPVZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 17:25:30 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:33621 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab3EPVZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 17:25:28 -0400
Message-ID: <51954B01.4070907@gmail.com>
Date: Thu, 16 May 2013 23:09:21 +0200
From: Cyril Roelandt <tipecaml@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: kernel-janitors@vger.kernel.org, andreas.dilger@intel.com,
        tao.peng@emc.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lustre: fix return type of lo_release.
References: <1368720380-20974-1-git-send-email-tipecaml@gmail.com> <20130516190130.GB2778@kroah.com>
In-Reply-To: <20130516190130.GB2778@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2013 09:01 PM, Greg KH wrote:
> On Thu, May 16, 2013 at 06:06:20PM +0200, Cyril Roelandt wrote:
>> The return type of block_device_operations.release() changed to void in commit
>> db2a144b.
>
> Interesting, how did you test build this patch, given that the driver
> doesn't currently build at all?  :)
>

Well, the patch seemed simple enough to be sent anyway :)

Cyril Roelandt.
