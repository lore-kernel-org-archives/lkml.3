Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbbALK7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 05:59:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55092 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbbALK7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 05:59:19 -0500
Message-ID: <54B3A90D.7080104@canonical.com>
Date: Mon, 12 Jan 2015 11:59:25 +0100
From: David Henningsson <david.henningsson@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Hans de Bruin <jmdebruin@xmsnet.nl>, Takashi Iwai <tiwai@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 3.19-rc1 regression bisected No sound on Dell Latitude d430
References: <54B26ACE.90406@xmsnet.nl> <s5hy4p92ue0.wl-tiwai@suse.de> <54B2EEC5.7050805@xmsnet.nl>
In-Reply-To: <54B2EEC5.7050805@xmsnet.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2015-01-11 22:44, Hans de Bruin wrote:
> running 3.19-rc1 alsamixer show these options:
>
> Master
> PCM
> Line Out
> Mic Boost
> Auto Mute mode
>
> Line out now controls the vole of the speaker (this 'new' channel had
> volume 0 so did not hear anything). Changing PCM has no effect.

So, now that you have adjusted "Line Out" you have sound again, correct?

Then this might be easiest resolved by just adding a "Line Out" section 
to /usr/share/alsa/init/default that intializes Line Out to something 
else than zero. We probably should do that anyway.

Takashi, do you agree? If so I'll write a patch for it.

-- 
David Henningsson, Canonical Ltd.
https://launchpad.net/~diwic
