Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab3G2PDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 11:03:47 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53103 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab3G2PDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 11:03:46 -0400
Message-ID: <51F6844C.7030109@wwwdotorg.org>
Date: Mon, 29 Jul 2013 09:03:40 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Felipe F. Tonello" <eu@felipetonello.com>
CC: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        David Henningsson <david.henningsson@canonical.com>,
        Wang Xingchao <xingchao.wang@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>
Subject: Re: [PATCH v2 3/3] ALSA: SoC: Updating jack implementation according
 new ALSA Jacks
References: <1374878713-11922-1-git-send-email-eu@felipetonello.com> <1374878713-11922-4-git-send-email-eu@felipetonello.com>
In-Reply-To: <1374878713-11922-4-git-send-email-eu@felipetonello.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2013 04:45 PM, Felipe F. Tonello wrote:
> Updating the ASoC jack support to add the ability to specify a
> jack index when creating it.

This also appears to rename a number of jacks. If that's intentional,
presumably it should be mentioned in the commit description?
