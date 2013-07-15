Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256Ab3GOPu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 11:50:59 -0400
Received: from smtp-out-191.synserver.de ([212.40.185.191]:1055 "EHLO
	smtp-out-191.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932679Ab3GOPu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 11:50:57 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 2264
Message-ID: <51E41A86.4030200@metafoo.de>
Date: Mon, 15 Jul 2013 17:51:34 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Matt Porter <matt@ohporter.com>
Subject: Re: [PATCH] dmaengine: add dma_slave_get_caps api
References: <1373273650-31097-1-git-send-email-vinod.koul@intel.com> <1373883687-10146-1-git-send-email-vinod.koul@intel.com>
In-Reply-To: <1373883687-10146-1-git-send-email-vinod.koul@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 12:21 PM, Vinod Koul wrote:
[...]
> + * @max_seg_nr: maximum number of SG segments supported
> + * 	0 for no maximum
> + * @max_seg_len: maximum length of a SG segment supported
> + * 	0 for no maximum
[...]
> +	u32 max_sg_nr;
> +	u32 max_sg_len;

seg vs. sg

