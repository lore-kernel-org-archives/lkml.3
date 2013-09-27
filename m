Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab3I0Nc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:32:27 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752206Ab3I0N2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:28:43 -0400
Message-ID: <52458809.6050704@nod.at>
Date: Fri, 27 Sep 2013 15:28:41 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UBI: simplify image sequence test
References: <1380286316-29911-1-git-send-email-richard.genoud@gmail.com> <1380286316-29911-2-git-send-email-richard.genoud@gmail.com>
In-Reply-To: <1380286316-29911-2-git-send-email-richard.genoud@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.09.2013 14:51, schrieb Richard Genoud:
> The test:
> if (!a && b)
>   a = b;
> can be symplified in:
> if (!a)
>   a = b;
> 
> And there's no need to test if ubi->image_seq is not null, because if it is,
> it is set to image_seq.
> So, we just test if image_seq is not null.
> 
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>

Acked-by: Richard Weinberger <richard@nod.at>

