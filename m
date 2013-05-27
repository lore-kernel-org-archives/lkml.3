Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab3E0ILI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 04:11:08 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756769Ab3E0ILH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 04:11:07 -0400
Message-ID: <51A3150C.7080009@nod.at>
Date: Mon, 27 May 2013 10:10:52 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thomas Weber <thomas@tomweber.eu>
CC: Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, wang bo <wang.bo116@zte.com.cn>
Subject: Re: [PATCH] UBI: Fastmap: Fix memory leak
References: <CAFLxGvw5gj-dfQeMKQVJpHPAXi4ZeNTaG3u3yXOAkshJRavXVA@mail.gmail.com> <1369641744-13534-1-git-send-email-thomas@tomweber.eu>
In-Reply-To: <1369641744-13534-1-git-send-email-thomas@tomweber.eu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Am 27.05.2013 10:02, schrieb Thomas Weber:
> Signed-off-by: wang bo <wang.bo116@zte.com.cn>
>
> [fix whitespace errors]
>
> Tested with linux-v3.10-rc3 on Devkit8000.
> Signed-off-by: Thomas Weber <thomas@tomweber.eu>
>
> The discussion about this patch can be found:
> https://lkml.org/lkml/2013/5/2/118

Thanks a lot for fixing the whitespace issues!
Am I allowed to add a Tested-by: Thomas Weber <thomas@tomweber.eu>?
IOW did you test the patch? :D

Thanks,
//richard
