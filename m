Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab3KGJsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 04:48:05 -0500
Received: from intranet.asianux.com ([58.214.24.6]:55754 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab3KGJr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 04:47:56 -0500
X-Spam-Score: -100.8
Message-ID: <527B624C.30500@asianux.com>
Date: Thu, 07 Nov 2013 17:50:04 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>
CC: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH] include/uapi/sound/firewire.h: use "_UAPI"
 instead of "UAPI"
References: <527B0595.5030108@asianux.com> <527B4746.90009@ladisch.de>
In-Reply-To: <527B4746.90009@ladisch.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2013 03:54 PM, Clemens Ladisch wrote:
> Chen Gang wrote:
>> > When installing, "scripts/headers_install.sh" will strip guard macro'
>> > "_UAPI" to prevent from appearing it to users. And also, all another
>> > files which need uapi prefix always use "_UAPI", not "UAPI".
>> >
>> > So use "_UAPI" instead of "UAPI" on the guard macro, and also give a
>> > comment for "#endif".
>> >
>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
> Acked-by: Clemens Ladisch <clemens@ladisch.de>
> 

Thank you very much !!

-- 
Chen Gang
