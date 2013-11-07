Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab3KGJrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 04:47:40 -0500
Received: from intranet.asianux.com ([58.214.24.6]:55748 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab3KGJrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 04:47:37 -0500
X-Spam-Score: -100.8
Message-ID: <527B6236.9090908@asianux.com>
Date: Thu, 07 Nov 2013 17:49:42 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: perex@perex.cz, "dhowells@redhat.com" <dhowells@redhat.com>,
        alsa-devel@alsa-project.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] include/uapi/sound/firewire.h: use "_UAPI" instead of
 "UAPI"
References: <527B0595.5030108@asianux.com> <s5hd2mcv9u5.wl%tiwai@suse.de>
In-Reply-To: <s5hd2mcv9u5.wl%tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2013 05:29 PM, Takashi Iwai wrote:
> At Thu, 07 Nov 2013 11:14:29 +0800,
> Chen Gang wrote:
>> > 
>> > When installing, "scripts/headers_install.sh" will strip guard macro'
>> > "_UAPI" to prevent from appearing it to users. And also, all another
>> > files which need uapi prefix always use "_UAPI", not "UAPI".
>> > 
>> > So use "_UAPI" instead of "UAPI" on the guard macro, and also give a
>> > comment for "#endif".
>> > 
>> > 
>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
> Thanks, applied.


Thank you very much !!

-- 
Chen Gang
