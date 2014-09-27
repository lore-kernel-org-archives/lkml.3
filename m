Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbaI0WyD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 18:54:03 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:42711 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbaI0WyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 18:54:00 -0400
Message-ID: <54274004.6010902@converseincode.com>
Date: Sat, 27 Sep 2014 15:53:56 -0700
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: balbi@ti.com
CC: plagnioj@jcrosoft.com, tomi.valkeinen@ti.com, daniel.vetter@ffwll.ch,
        geert@linux-m68k.org, laurent.pinchart@ideasonboard.com,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, robdclark@gmail.com,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/2] arm, fbdev, omap2, LLVMLinux: Remove nested function
 from omap2 dss
References: <1411780253-4492-1-git-send-email-behanw@converseincode.com> <1411780253-4492-2-git-send-email-behanw@converseincode.com> <20140927164554.GA7076@saruman>
In-Reply-To: <20140927164554.GA7076@saruman>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/14 09:46, Felipe Balbi wrote:
> On Fri, Sep 26, 2014 at 06:10:52PM -0700, Behan Webster wrote:
>> Replace the use of nested functions where a normal function will suffice.
>>
>> Nested functions are not liked by upstream kernel developers in general. Their
>> use breaks the use of clang as a compiler, and doesn't make the code any
>> better.
>>
>> This code now works for both gcc and clang.
>>
>> Signed-off-by: Behan Webster <behanw@converseincode.com>
>> Suggested-by: Arnd Bergmann <arnd@arndb.de>
>> Cc: Arnd Bergmann <arnd@arndb.de>
> another one that make sense :-) And probably also deserves
> checkpatch/coccinelle/sparse.
Indeed! That would be very appreciated.

The clang static analyzer already points this one out. :)

Behan

-- 
Behan Webster
behanw@converseincode.com

