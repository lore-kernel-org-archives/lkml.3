Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935416Ab3BTOrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 09:47:13 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:63890 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933257Ab3BTOrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 09:47:11 -0500
Message-ID: <5124E1E9.5060607@suse.cz>
Date: Wed, 20 Feb 2013 15:47:05 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: stable <stable@vger.kernel.org>
CC: Marcin Slusarz <marcin.slusarz@gmail.com>, bskeggs@redhat.com,
        dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>
Subject: [stable request] fix for nouveau mem corruption [was: WARNING: at
 drivers/gpu/drm/nouveau/core/core/mm.c:242]
References: <5122021F.1060207@suse.cz> <20130218232335.GA9730@joi.lan> <5122BC8A.6040503@suse.cz> <20130219070744.GA3032@joi.lan>
In-Reply-To: <20130219070744.GA3032@joi.lan>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 08:07 AM, Marcin Slusarz wrote:
>>> Crash/warning should be fixed by commit cfd376b6bfccf33782a0748a9c70f7f752f8b869
>>> "drm/nouveau/vm: fix memory corruption when pgt allocation fails".
>>
>> Oh, thanks for the pointer. Could that bug cause real "memory
>> corruption"? As we're hunting one there...
> 
> Yes.
> 
>> Isn't this a stable-3.7 candidate?
> 
> Should have been :/.

Ok, if you have no objections: stable fellows, please consider the
commit above for stable inclusion. As far as I can tell this is only
applicable for 3.7 -- Marcin?

-- 
js
suse labs
