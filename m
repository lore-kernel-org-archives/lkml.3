Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606Ab3LDO6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 09:58:14 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:58444 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932301Ab3LDO6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 09:58:13 -0500
Message-ID: <529F42E4.8080703@ti.com>
Date: Wed, 4 Dec 2013 09:57:40 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mm@kvack.org>, Grygorii Strashko <grygorii.strashko@ti.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 06/23] mm/char: remove unnecessary inclusion of bootmem.h
References: <1386037658-3161-1-git-send-email-santosh.shilimkar@ti.com> <1386037658-3161-7-git-send-email-santosh.shilimkar@ti.com> <20131203225513.GV8277@htj.dyndns.org>
In-Reply-To: <20131203225513.GV8277@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 December 2013 05:55 PM, Tejun Heo wrote:
> On Mon, Dec 02, 2013 at 09:27:21PM -0500, Santosh Shilimkar wrote:
>> From: Grygorii Strashko <grygorii.strashko@ti.com>
>>
>> Clean-up to remove depedency with bootmem headers.
>>
>> Cc: Yinghai Lu <yinghai@kernel.org>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> 
> Please merge 4-6 into a single patch.
> 
Will do

