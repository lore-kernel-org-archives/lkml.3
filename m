Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab3GXIJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 04:09:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:45310 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab3GXIIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 04:08:51 -0400
X-AuditID: cbfee691-b7fef6d000002d62-d6-51ef8b913d0d
From: Jingoo Han <jg1.han@samsung.com>
To: Michal Simek <monstr@monstr.eu>
Cc: "'Michal Simek'" <michal.simek@xilinx.com>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Stepan Moskovchenko'" <stepanm@codeaurora.org>,
        Jingoo Han <jg1.han@samsung.com>
References: <ed64cda456be840147ae1f04bec6a99733f41c24.1374643896.git.michal.simek@xilinx.com>
 <007401ce8833$22ce0600$686a1200$@samsung.com> <51EF7FBD.8070103@monstr.eu>
 <51EF8530.90809@monstr.eu>
In-reply-to: <51EF8530.90809@monstr.eu>
Subject: Re: [PATCH] video: xilinxfb: Fix compilation warning
Date: Wed, 24 Jul 2013 17:08:48 +0900
Message-id: <003a01ce8845$06df46e0$149dd4a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQDhIjeOE8YCk8uEU8q7i3UDvN0bdgHIC927AUUv8csBkNX9qJspUr8w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsVy+t8zY92J3e8DDS6d5bS4vPASq8WJvg+s
	Fpd3zWGzePcywuLJx9MsFusevmCyeLnI1WL9/FtsDhwel/t6mTxeXbjD4vG3awqzR9+WVYwe
	x29sZ/L4vEnOY+/n3ywB7FFcNimpOZllqUX6dglcGU8mLmMsmCVf0bhwNVsD42XxLkZODgkB
	E4knB9awQ9hiEhfurWfrYuTiEBJYxijRuGU5E0zR0b1djBCJRYwSPR/2QDm/GCX+fFnKClLF
	JqAm8eXLYbBRIgLKEk+3rAAbxSywnEni8vvnTBAdJxklLnesYAGp4hRQl5j6dS4ziC0sYCvx
	orudDcRmEVCVaNr+AayGV8BS4u/3iYwQtqDEj8n3wOLMAloS63ceZ4Kw5SU2r3nLDHGrgsSO
	s68ZIa5wkzjYd5ANokZEYt+Ld2BnSwg0ckhcvTGJBWKZgMS3yYeAbA6ghKzEpgNQcyQlDq64
	wTKBUWIWktWzkKyehWT1LCQrFjCyrGIUTS1ILihOSi8y1StOzC0uzUvXS87P3cQIie+JOxjv
	H7A+xJgMtH4is5Rocj4wPeSVxBsamxlZmJqYGhuZW5qRJqwkzqveYh0oJJCeWJKanZpakFoU
	X1Sak1p8iJGJg1OqgfEkp7uNXsfstqP8YUV7t/Mf9PlgI78ySErpvvIxO8awsFsNPSzv0lvW
	751au0SE59PBBYkeXefyN9xU2n/52f9zjE0HfhzwP8to4hUb3p4XEZ0y58avmquXRdQvT9G2
	vmT6/ipz1/rwB4t47tQ5/Au1XsTy8sbL34yfCxN3dK6dU7TDN/Lqv0AlluKMREMt5qLiRAAx
	zjhOBQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPKsWRmVeSWpSXmKPExsVy+t9jAd2J3e8DDdr3s1hcXniJ1eJE3wdW
	i8u75rBZvHsZYfHk42kWi3UPXzBZvFzkarF+/i02Bw6Py329TB6vLtxh8fjbNYXZo2/LKkaP
	4ze2M3l83iTnsffzb5YA9qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8
	xNxUWyUXnwBdt8wcoKOUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBlP
	Ji5jLJglX9G4cDVbA+Nl8S5GTg4JAROJo3u7GCFsMYkL99azdTFycQgJLGKU6PmwhxHC+cUo
	8efLUlaQKjYBNYkvXw6zg9giAsoST7esAOtgFljOJHH5/XMmiI6TjBKXO1awgFRxCqhLTP06
	lxnEFhawlXjR3c4GYrMIqEo0bf8AVsMrYCnx9/tERghbUOLH5HtgcWYBLYn1O48zQdjyEpvX
	vGWGuFVBYsfZ14wQV7hJHOw7yAZRIyKx78U7xgmMQrOQjJqFZNQsJKNmIWlZwMiyilE0tSC5
	oDgpPddQrzgxt7g0L10vOT93EyM4eTyT2sG4ssHiEKMAB6MSD2/BrHeBQqyJZcWVuYcYJTiY
	lUR4Fze/DxTiTUmsrEotyo8vKs1JLT7EmAz06URmKdHkfGBiyyuJNzQ2MTOyNDKzMDIxNydN
	WEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkGxgrLZTkRGx8/emHEIMGTa9pQHDp3Zp+dcLno
	Wd3dW3vszfJevGrcZ/uycPOdC2l3byiELj28MtfltP53kT0VNmdm8BaEv8h+sY3xaPYs+wtO
	gjyS11fU7eGuOZxzyOVCc8XlHxOzFDNq+B6Le7otFljt86zd9O0W65fRu5hFFG5m/hPW27Iy
	XomlOCPRUIu5qDgRAJNYigtiAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 24, 2013 4:42 PM, Michal Simek wrote:
> On 07/24/2013 09:18 AM, Michal Simek wrote:
> > On 07/24/2013 08:00 AM, Jingoo Han wrote:
> >> On Wednesday, July 24, 2013 2:32 PM, Michal Simek wrote:
> >>>
> >>> regs_phys is phys_addr_t (u32 or u64).
> >>> Lets retype it to u64.
> >>>
> >>> Fixes compilation warning introduced by:
> >>> video: xilinxfb: Use drvdata->regs_phys instead of physaddr
> >>> (sha1: c88fafef0135e1e1c3e23c3e32ccbeeabc587f81)
> >>
> >> CC'ed Stepan Moskovchenko
> >>
> >>
> >> phys_addr_t is defined as below:
> >>
> >> #ifdef CONFIG_PHYS_ADDR_T_64BIT
> >> typedef u64 phys_addr_t;
> >> #else
> >> typedef u32 phys_addr_t;
> >> #endif
> >>
> >> According to 'Documentation/printk-formats.txt',
> >> Physical addresses:
> >>        %pa     0x01234567 or 0x0123456789abcdef
> >>        For printing a phys_addr_t type (and its derivatives, such as
> >>        resource_size_t) which can vary based on build options, regardless of
> >>        the width of the CPU data path. Passed by reference.
> >>
> >> Thus, '%pa' option looks proper, instead of casting (unsigned long long).
> >>
> >> 		dev_dbg(dev, "regs: phys=%pa, virt=%p\n", drvdata->regs_phys,
> >> 					drvdata->regs);
> >>
> >
> > Ah. Wasn't aware about that.
> > Will retest.
> 
> On ppc44x_defconfig
> 
> $ powerpc-unknown-linux-gnu-gcc --version
> powerpc-unknown-linux-gnu-gcc (crosstool-NG-svn_unknown@20110406.104745) 4.3.2
> 
> This fix
> diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
> index 79175a6..a9a1167 100644
> --- a/drivers/video/xilinxfb.c
> +++ b/drivers/video/xilinxfb.c
> @@ -341,12 +341,12 @@ static int xilinxfb_assign(struct platform_device *pdev,
> 
>         if (drvdata->flags & BUS_ACCESS_FLAG) {
>                 /* Put a banner in the log (for DEBUG) */
> -               dev_dbg(dev, "regs: phys=%llx, virt=%p\n",
> -                       (unsigned long long)drvdata->regs_phys, drvdata->regs);
> +               dev_dbg(dev, "regs: phys=%pa, virt=%p\n",
> +                       drvdata->regs_phys, drvdata->regs);
>         }
>         /* Put a banner in the log (for DEBUG) */
> -       dev_dbg(dev, "fb: phys=%llx, virt=%p, size=%x\n",
> -               (unsigned long long)drvdata->fb_phys, drvdata->fb_virt, fbsize);
> +       dev_dbg(dev, "fb: phys=%pa, virt=%p, size=%x\n",
> +               drvdata->fb_phys, drvdata->fb_virt, fbsize);
> 

Hi Michal Simek,

Just now, I tested that the same problem happens on ARM config.
Also, I solved it by adding '&' operator.

'&' operator is necessary as below:

        dev_dbg(dev, "regs: phys=%pa, virt=%p\n",
                 &drvdata->regs_phys, drvdata->regs);
                ^^^

        dev_dbg(dev, "fb: phys=%pa, virt=%p, size=%x\n",
                &drvdata->fb_phys, drvdata->fb_virt, fbsize);
               ^^^

Best regards,
Jingoo Han

>         return 0;       /* success */
> 
> Generates two warnings even it should be ok according to link to specification you sent.
>   CC [M]  drivers/video/xilinxfb.o
> drivers/video/xilinxfb.c: In function 'xilinxfb_assign':
> drivers/video/xilinxfb.c:344: warning: format '%p' expects type 'void *', but argument 4 has type
> 'phys_addr_t'
> drivers/video/xilinxfb.c:348: warning: format '%p' expects type 'void *', but argument 4 has type
> 'dma_addr_t'
> 
> On microblaze toolchain I see the same warnings. (mmu_defconfig)
> 
> I have also grepped the kernel and I see that it is used in 4 c files which seems to me
> weird because phy_addr_t or dma_addr_t are used on a lot of places.
> 
> Thanks,
> Michal
> 
> --
> Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
> w: www.monstr.eu p: +42-0-721842854
> Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
> Maintainer of Linux kernel - Xilinx Zynq ARM architecture
> Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform
> 


