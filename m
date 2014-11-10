Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbaKJHUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 02:20:41 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:58543 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaKJHUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 02:20:37 -0500
Date: Mon, 10 Nov 2014 12:50:26 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ALSA: korg1212: cleanup of printk
Message-ID: <20141110072026.GA12553@sudip-PC>
References: <1415603671-12510-1-git-send-email-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415603671-12510-1-git-send-email-sudipm.mukherjee@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Takashi,
I have a doubt regarding this korg1212.
snd_korg1212_free_pcm is just making korg1212->pcm as NULL. But are we not supposed to release the allocated memory ?
in snd_pcm_new we are allocating memory.

thanks
sudip

