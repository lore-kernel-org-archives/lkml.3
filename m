Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab3ATQD4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 11:03:56 -0500
Received: from nm9-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.154]:28628 "HELO
	nm9-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752028Ab3ATQDy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 11:03:54 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 913768.72147.bm@omp1061.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=w6oBW4lzCi210vjuebVVUdyQl7D8xY3B2B0jiF4sHwuCH56XijIixQRDMimhhwxBaTF+C5QiuXr0sXc4BJ5yCGB1pcW0nL+O+sZlChI+mwdnnpKlSwBo6PBzjHLWJwM30efbQa2yUUGUm4VT6m6rX/V0vAJhpLftwI5X2oq+q5k=;
X-YMail-OSG: fxSmR88VM1m4YqfTBzEVCk5dQXI2t5yY2_CqcMHZHyeyyJv
 JWsdnomUesJUt28ycKOyEc3InGiKHNOBnofewsZFYcR5MIKXBMuEbhL0hp7P
 u8k.qkVyCBPiEtbpTsUPnner1LRrdOm70yHSg1BI1mU3mWIkXEI4JK2_xaTE
 Zz_VlNOBWwdDrOH4wjGGLzxHxoSggHqgAqeRqmFm3WUyw76duXJKOSfsfkoG
 NSbhtlQ9X3Wgu_WJFKT0YDYCOrAZmbTbpsF9_VWKuXcTmcbV7hrgSxC9ksCv
 i5Jrp7CcNBvmqUdPD0l11UVVUFANqF1P.sBGlLPr4FSiudh05.r0XUSFnBvs
 xPTJo6WC.mGY0BNi104I_nGG9tK3ttZNeCZE.9m9yoss6ppQQF5bujfps6b8
 g3r7_Q1YE3SbWHbYyKDG0Uf3OT55RnjGXT05CwP20C1wj_SVNVu7xNh7SOm6
 shTjXC4JaZRUYj37EPYptRSgo0jQ30f5R0YWoyit7hC1eV6fdhuaPwN0wl2l
 QKdiW1nRhSpApUNh1tzJTvyMCcvsp_9OkN.WoMUZSOzUFz1Bz5xAy4C6BGwn
 v7dVppUjJ75BenW0iAED6BHvnOHDJGqIZR8nEhHu7R7Wx9mVWIcBgPo0oo1R
 7qM8QHVxm9woP1LUV_z.mXfPDWdBz7v_vCtfb
X-Rocket-MIMEInfo: 001.001,SGksCgpDYW4gYW55Ym9keSBwcm92aWRlIGFueSBpbnB1dHMvc3VnZ2VzdGlvbnMvaW1wcm92ZW1lbnRzIG9uIHRoZSBmb2xsb3dpbmcuCgpBY2NvcmRpbmcgdG8gbXkgZXhwZXJpbWVudHMgdGhlc2UgcHJvdmVkIHRvIGJlIGEgdXNlZnVsIHV0aWxpdHkgZHVyaW5nIGxvdyBtZW1vcnkgY29uZGl0aW9uIG9uIHRoZSBlbWJlZGRlZCBkZXZpY2VzLgpJcyB0aGVyZSBzb21ldGhpbmcgd3JvbmcgSSBhbSBkb2luZz8KClBsZWFzZSBwcm92aWRlIHlvdXIgc3VnZ2VzdGlvbnMuCgpUaGFua3MsClBpbnR1CgoKCj5fX18BMAEBAQE-
X-Mailer: YahooMailWebService/0.8.130.494
References: <1334483226.20721.YahooMailNeo@web162003.mail.bf1.yahoo.com> <CAFLxGvwJCMoiXFn3OgwiX+B50FTzGZmo6eG3xQ1KaPsEVZVA1g@mail.gmail.com> <1334490429.67558.YahooMailNeo@web162006.mail.bf1.yahoo.com> <CAFLxGvz5tmEi-39CZbJN+0zNd3ZpHXzZcNSFUpUWS_aMDJ4t6Q@mail.gmail.com> <20120418211032.47b243da@pyramind.ukuu.org.uk> <1334842941.92324.YahooMailNeo@web162006.mail.bf1.yahoo.com> <1358091177.96940.YahooMailNeo@web160103.mail.bf1.yahoo.com>
Message-ID: <1358697833.56285.YahooMailNeo@web160102.mail.bf1.yahoo.com>
Date: Sun, 20 Jan 2013 08:03:53 -0800 (PST)
From: PINTU KUMAR <pintu_agarwal@yahoo.com>
Reply-To: PINTU KUMAR <pintu_agarwal@yahoo.com>
Subject: Re: Introducing Aggressive Low Memory Booster [1]
To: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "pintu.k@samsung.com" <pintu.k@samsung.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "patches@linaro.org" <patches@linaro.org>,
        Mel Gorman <mgorman@suse.de>, Wanpeng Li <liwanp@linux.vnet.ibm.com>
In-Reply-To: <1358091177.96940.YahooMailNeo@web160103.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Can anybody provide any inputs/suggestions/improvements on the following.

According to my experiments these proved to be a useful utility during low memory condition on the embedded devices.
Is there something wrong I am doing?

Please provide your suggestions.

Thanks,
Pintu



>________________________________
> From: PINTU KUMAR <pintu_agarwal@yahoo.com>
>To: "linux-mm@kvack.org" <linux-mm@kvack.org>; "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org> 
>Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>; "pintu.k@samsung.com" <pintu.k@samsung.com>; Anton Vorontsov <anton.vorontsov@linaro.org>; Alan Cox <alan@lxorguk.ukuu.org.uk>; richard -rw- weinberger <richard.weinberger@gmail.com>; "patches@linaro.org" <patches@linaro.org>; Mel Gorman <mgorman@suse.de>; Wanpeng Li <liwanp@linux.vnet.ibm.com> 
>Sent: Sunday, 13 January 2013 9:02 PM
>Subject: Introducing Aggressive Low Memory Booster [1]
> 
>
>Hi,
>
>
>Here I am trying to introduce a new feature in kernel called "Aggressive Low Memory Booster".
>The main advantage of this will be to boost the available free memory of the system to "certain level" during extremely low memory condition.
>
>
>Please provide your comments to improve further.
>Can it be used along with vmpressure_fd ???
>
>
>
>It can be invoked as follows:
>    a) Automatically by kernel memory management when the memory threshold falls below 10MB.
>    b) From user space program/scripts by passing the "required amount of memory to be reclaimed".
>    Example: echo 100 > /dev/shrinkmem
>    c) using sys interface - /sys/kernel/debug/shrinkallmem
>    d) using an ioctl call and returning number of pages reclaimed.
>    e) using a new system call - shrinkallmem(&nrpages);
>    f) During CMA to reclaim and shrink a specific CMA regions.
>
>
>
>I have developed a kernel module to verify the (b) part.
>
>
>Here is the snapshot of the write call:
>+static ssize_t shrinkmem_write(struct file *file, const char *buff,
>+                                size_t length, loff_t *pos)
>+{
>+        int ret = -1;
>+        unsigned long memsize = 0;
>+        unsigned long nr_reclaim = 0;
>+        unsigned long pages = 0;
>+        ret = kstrtoul_from_user(buff, length, 0, &memsize);
>+        if (ret < 0) {
>+                printk(KERN_ERR "[SHRINKMEM]: kstrtoul_from_user: Failed !\n");
>+                return
-1;
>+        }
>+        printk(KERN_INFO "[SHRINKMEM]: memsize(in MB) = %ld\n",
>+                                (unsigned long)memsize);
>+        memsize = memsize*(1024UL*1024UL);
>+        nr_reclaim = memsize / PAGE_SIZE;
>+        pages = shrink_all_memory(nr_reclaim);
>+        printk(KERN_INFO "<SHRINKMEM>: Number of Pages Freed: %lu\n", pages);
>+        return pages;
>+}
>Please note: This requires CONFIG_HIBERNATION to be permanently enabled in the kernel.
>
>
>Several experiments have been performed on Ubuntu(kernel 3.3) to verify it under low memory conditions.
>
>
>Following are some results obtained:
>-------------------------------------
>
>Node 0, zone      DMA    290    115      0      0      0      0      0      0      0      0      0
>Node 0, zone   Normal    304    540    116     13      2      2      0      0      0      0      0
>=========================
>             total      
used       free     shared    buffers     cached
>Mem:           497        487         10          0         63        303
>-/+ buffers/cache:        120        376
>Swap:         1458         34       1424
>Total:        1956        522       1434
>=========================
>Total Memory Freed: 342 MB
>Total Memory Freed: 53 MB
>Total
Memory Freed: 23 MB
>Total Memory Freed: 10 MB
>Total Memory Freed: 15 MB
>Total Memory Freed: -1 MB
>Node 0, zone      DMA      6      6      7      8     10      9      7      4      1      0      0
>Node 0, zone   Normal   2129   2612   2166   1723   1260    759    359    108     10      0      0
>=========================
>             total      
used       free     shared    buffers     cached
>Mem:           497         47        449          0          0          5
>-/+ buffers/cache:         41        455
>Swap:         1458         97       1361
>Total:        1956        145       1811
>=========================
>
>
>It was verified using a sample shell script "reclaim_memory.sh" which keeps recovering memory by doing "echo 500 > /dev/shrinkmem" until no further reclaim is possible.
>
>
>The experiments were performed with various scenarios as follows:
>a) Just after the boot up - (could recover around 150MB with 512MB RAM)
>b) After running many applications include youtube videos, large tar files download - 
>
>   [until free mem becomes < 10MB]
>   [Could recover around 300MB in one shot]
>c) Run reclaim, while download is in progress and video still playing - (Not applications killed)
>
>d) revoke all background applications again, after running reclaim - (No impact, normal behavior)
>   [Just it took little extra time to launch, as if it was launched for first time]
>
>
>
>
>Please see more discussions on this in the last year mailing list:
>
>https://lkml.org/lkml/2012/4/15/35
>
>
>
>Thank You!
>With regards,
>Pintu Kumar
>Samsung - India
>
>
>
>
>
>
