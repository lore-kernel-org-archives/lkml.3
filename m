Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686Ab3GCJhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 05:37:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687Ab3GCJhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 05:37:13 -0400
Message-ID: <51D3F0BE.8060109@redhat.com>
Date: Wed, 03 Jul 2013 11:37:02 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH staging-next] zram: protect zram_reset_device() call
References: <20130626122839.GA2268@swordfish.minsk.epam.com>
In-Reply-To: <20130626122839.GA2268@swordfish.minsk.epam.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 02:28 PM, Sergey Senozhatsky wrote:
> Commit 9b3bb7abcdf2df0f1b2657e6cbc9d06bc2b3b36f (remove
> zram_sysfs file (v2)) accidentally made zram_reset_device()
> racy. Protect zram_reset_device() call with zram->lock.
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Acked-by: Jerome Marchand <jmarchand@redhat.com>

