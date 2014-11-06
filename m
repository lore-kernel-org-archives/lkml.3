Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbaKFNRN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 08:17:13 -0500
Received: from smtp-out-006.synserver.de ([212.40.185.6]:1074 "EHLO
	smtp-out-002.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751021AbaKFNRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 08:17:11 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 2730
Message-ID: <545B74D7.4060400@metafoo.de>
Date: Thu, 06 Nov 2014 14:17:11 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Peter Rosin <peda@lysator.liu.se>, alsa-devel@alsa-project.org
CC: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Peter Rosin <peda@axentia.se>, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 2/2] ASoC: tfa9879: Add bass and treble gain/freq
 controls.
References: <1415278441-27866-1-git-send-email-peda@lysator.liu.se> <1415278441-27866-3-git-send-email-peda@lysator.liu.se>
In-Reply-To: <1415278441-27866-3-git-send-email-peda@lysator.liu.se>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2014 01:54 PM, Peter Rosin wrote:
> From: Peter Rosin <peda@axentia.se>
>
> Signed-off-by: Peter Rosin <peda@axentia.se>
> ---
>   sound/soc/codecs/tfa9879.c |   16 ++++++++++++++++
>   1 file changed, 16 insertions(+)

Is there any specific reason why this is separate and not part of the 
initial patch?

