Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777AbaAAMK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 07:10:59 -0500
Received: from smtp-out-180.synserver.de ([212.40.185.180]:1027 "EHLO
	smtp-out-079.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753480AbaAAMK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 07:10:58 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 5040
Message-ID: <52C405DD.1080006@metafoo.de>
Date: Wed, 01 Jan 2014 13:11:09 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Xiubo Li <Li.Xiubo@freescale.com>
CC: broonie@kernel.org, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        fabio.estevam@freescale.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, kuninori.morimoto.gx@renesas.com
Subject: Re: [alsa-devel] [PATCH] ASoC: simple-card: Add device's module clock
 selection.
References: <1387783538-5318-1-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1387783538-5318-1-git-send-email-Li.Xiubo@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2013 08:25 AM, Xiubo Li wrote:
> diff --git a/a.out b/a.out
> new file mode 100644
> index 0000000..e69de29

This patch did add a empty a.out file in the toplevel folder.

- Lars

