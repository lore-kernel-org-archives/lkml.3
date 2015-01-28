Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761460AbbA1WEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 17:04:42 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:33552 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483AbbA1UWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:22:51 -0500
Message-ID: <54C92072.9080404@suse.cz>
Date: Wed, 28 Jan 2015 18:46:26 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Johan Hovold <johan@kernel.org>
CC: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 3.12 140/176] gpio: sysfs: fix gpio device-attribute leak
References: <cover.1422455352.git.jslaby@suse.cz> <e66a96f38a5a35c96eadcabbe20921ad32ed087a.1422455352.git.jslaby@suse.cz> <20150128161007.GC2433@localhost>
In-Reply-To: <20150128161007.GC2433@localhost>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2015, 05:10 PM, Johan Hovold wrote:
> On Wed, Jan 28, 2015 at 03:29:30PM +0100, Jiri Slaby wrote:
>> From: Johan Hovold <johan@kernel.org>
>>
>> 3.12-stable review patch.  If anyone has any objections, please let me know.
>>
>> ===============
>>
>> commit 0915e6feb38de8d3601819992a5bd050201a56fa upstream.
>>
>> The gpio device attributes were never destroyed when the gpio was
>> unexported (or on export failures).
>>
>> Use device_create_with_groups() to create the default device attributes
>> of the gpio class device. Note that this also fixes the
>> attribute-creation race with userspace for these attributes.
>>
>> Remove contingent attributes in export error path and on unexport.
>>
>> Fixes: d8f388d8dc8d ("gpio: sysfs interface")
>> Signed-off-by: Johan Hovold <johan@kernel.org>
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> 
> There was a mistake in the 3.14 (and 3.12) backport. A fixed v2 backport
> has been posted in this thread:
> 
> 	https://marc.info/?l=linux-kernel&m=142241055931689&w=2

But there is no thread. Could you repost?


-- 
js
suse labs
