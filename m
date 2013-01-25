Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab3AYCWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 21:22:22 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:21481 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab3AYCWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 21:22:08 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-c9-5101ec4ef0d6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Dan Carpenter'" <dan.carpenter@oracle.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Inki Dae'" <inki.dae@samsung.com>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <20130124070524.GD5611@elgon.mountain>
In-reply-to: <20130124070524.GD5611@elgon.mountain>
Subject: Re: [patch] backlight: s6e63m0: report ->gamma_table_count correctly
Date: Fri, 25 Jan 2013 11:22:06 +0900
Message-id: <00c601cdfaa2$c52d03c0$4f870b40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac36ATx3w/DyYfDoSGGA6wXDWt6rMgAoLK/A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t8zQ12/N4yBBi9XqFtsvSVtcaLvA6vF
	5V1z2ByYPT5vkgtgjOKySUnNySxLLdK3S+DKmHLjBkvBWu6Kb9c/sjYwTuTsYuTkkBAwkTi1
	YgEjhC0mceHeerYuRi4OIYFljBJHjj5n6WLkACs6+SADIj6dUaL77X4WCOcXo8Tu1dtZQbrZ
	BNQkvnw5zA5iiwjoSUxdvJ8JpIhZYAeTRMOqy0wgCSEBI4mDW1aCFXEKGEtsXbAGbLWwgK/E
	93O7wWwWAVWJyz+Pgw3lFbCVmL34MyOELSjxY/I9FhCbWUBLYv3O40wQtrzE5jVvmSEuVZd4
	9FcX4gYjiVu7VkCViEjse/EO6stN7BLXP8pCrBKQ+Db5ENSTshKbDjBDlEhKHFxxg2UCo8Qs
	JItnIVk8C8niWUg2LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kREmtSOxhXNlgcYhTg
	YFTi4bVIYwwUYk0sK67MPcQowcGsJMLrEgEU4k1JrKxKLcqPLyrNSS0+xJgMdOxEZinR5Hxg
	GsgriTc0NjYxMzE1Mbc0NTclTVhJnJfx1JMAIYH0xJLU7NTUgtQimC1MHJxSDYwXk6922J8O
	+lpdL9p+3jLZiNtv6Wu23SH+19qMDdL1A4sefQ+41/+5YIO7W1RHROeuxUkqiTPlT6Wd3N22
	MCT/z8VHbZmvrqS/bZn2yXiGh1Fzx69ll3nFq18t32L7aHOmz+vEv+p/ft0W2Nyw03tlyw+N
	6kixlKCov4dNT52Ukf9ybuHEcHYlluKMREMt5qLiRADLlRQY+QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jQV2/N4yBBpsmKltsvSVtcaLvA6vF
	5V1z2ByYPT5vkgtgjGpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21
	VXLxCdB1y8wBGq+kUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzJhy4wZL
	wVruim/XP7I2ME7k7GLk4JAQMJE4+SCji5ETyBSTuHBvPVsXIxeHkMB0Ronut/tZIJxfjBK7
	V29nBaliE1CT+PLlMDuILSKgJzF18X4mkCJmgR1MEg2rLjOBJIQEjCQOblkJVsQpYCyxdcEa
	RhBbWMBX4vu53WA2i4CqxOWfx8GG8grYSsxe/JkRwhaU+DH5HguIzSygJbF+53EmCFteYvOa
	t8wQV6tLPPqrC3GDkcStXSugSkQk9r14xziBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQn
	peca6hUn5haX5qXrJefnbmIEx/IzqR2MKxssDjEKcDAq8fBapDEGCrEmlhVX5h5ilOBgVhLh
	dYkACvGmJFZWpRblxxeV5qQWH2JMBnp0IrOUaHI+MM3klcQbGpuYGVkamVkYmZibkyasJM7L
	eOpJgJBAemJJanZqakFqEcwWJg5OqQZG452nte49/rNiWdwvmwgxn3a3hhdNu6Nn6XzkW5my
	eUmgm8UXpyXn1l15lfP/67J6paNOr5XfWP15aan7YT+794ktO55tnFh/+uES3Xaeizdsrqb2
	vH8+penYnP3Nal0CLdULmxk0clfeSKp94tWzqV+y6zZvV7Spyn/NFQfux/tzRV4UjtWZqcRS
	nJFoqMVcVJwIAKhp7aYpAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 24, 2013 10:45 PM, Dan Carpenter wrote

CC'ed Andrew Morton, Inki Dae.

> 
> gamma_table has 3 arrays which each hold MAX_GAMMA_LEVEL pointers to
> int.
> 
> The current code sets ->gamma_table_count to 6 on 64bit arches and to 3
> on 32 bit arches.  It should be 3 on everything.

Actually, I don't know it is right.
However, it is certain that this panel is currently used on 32 bit arches
such as ARM SoCs.

> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> This is from reading the code.  We use ->gamma_table_count in sysfs file
> but other than that I'm not sure what it's for.  I am not very familiar
> with this code.
> 
> diff --git a/drivers/video/backlight/s6e63m0.c b/drivers/video/backlight/s6e63m0.c
> index 2126b96..9c2677f 100644
> --- a/drivers/video/backlight/s6e63m0.c
> +++ b/drivers/video/backlight/s6e63m0.c
> @@ -766,7 +766,7 @@ static int s6e63m0_probe(struct spi_device *spi)
>  	 * know that.
>  	 */
>  	lcd->gamma_table_count =
> -	    sizeof(gamma_table) / (MAX_GAMMA_LEVEL * sizeof(int));
> +	    sizeof(gamma_table) / (MAX_GAMMA_LEVEL * sizeof(int *));
> 
>  	ret = device_create_file(&(spi->dev), &dev_attr_gamma_mode);
>  	if (ret < 0)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

