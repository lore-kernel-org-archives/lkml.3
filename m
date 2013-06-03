Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab3FCHCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 03:02:48 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22478 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3FCHCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 03:02:43 -0400
X-AuditID: cbfee691-b7fef6d000002d62-e6-51ac3f8ca9a4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andy Shevchenko'" <andy.shevchenko@gmail.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        "'Lee Jones'" <lee.jones@linaro.org>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Srinidhi Kasagar'" <srinidhi.kasagar@stericsson.com>,
        Jingoo Han <jg1.han@samsung.com>
References: <000501ce5e97$73e05f40$5ba11dc0$@samsung.com>
 <CAHp75VeUzyURf=fpzW2nW-BYio06GE7C_9BXyxsrjEdQhzGQgg@mail.gmail.com>
In-reply-to: <CAHp75VeUzyURf=fpzW2nW-BYio06GE7C_9BXyxsrjEdQhzGQgg@mail.gmail.com>
Subject: Re: [PATCH] mfd: replace strict_strtoul() with kstrtoul()
Date: Mon, 03 Jun 2013 16:02:35 +0900
Message-id: <000001ce6028$537025a0$fa5070e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIHDRGw0XP+Yc/PUR3zguPcjcCXBwHYZsTkmKNypsA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t8zQ90e+zWBBifuclq8nHCY0eLywkus
	Fve/HmW0mPJnOZPF5V1z2CxOd7Na3NrSxObA7rFz1l12jzvX9rB5zDsZ6NG3ZRWjx/ela9g9
	Pm+SC2CL4rJJSc3JLEst0rdL4Mq4e+8JU8F5wYqr/R9ZGxg/c3cxcnJICJhIvDp5lw3CFpO4
	cG89kM3FISSwjFHi4eZr7DBFn75sYIVITGeUmHD5JAtIQkjgF6PEkneOIDabgJrEly+HwRpE
	BAwl5j46wwzSwCzwg1Fi641JjBDdDYwSj+buAnI4ODgFgiV2b7IBaRAWcJI4uHQTE4jNIqAq
	0XJnKSuIzStgKXFxyTUoW1Dix+R7LCCtzALqElOm5IKEmQXkJTavecsMcaiCxI6zrxkhbrCS
	WHZ8DgtEjYjEvhfvwE6QEPjJLnFs2kZWiF0CEt8mHwKbKSEgK7HpANQcSYmDK26wTGCUmIVk
	8yyEzbOQbJ6FZMMCRpZVjKKpBckFxUnpRaZ6xYm5xaV56XrJ+bmbGCExPHEH4/0D1ocYk4G2
	T2SWEk3OB6aAvJJ4Q2MzIwtTE1NjI3NLM9KElcR51VusA4UE0hNLUrNTUwtSi+KLSnNSiw8x
	MnFwSjUw1l50e569W25Cw6+3l1tt4ydO2H/iQMfbw6lybRoM/UnlqhvWlK9oPq55YlHvl9BD
	xwOV2D5cmb/mtmdzBlNwz0JW0ZibKh9qDwhHbhDI/xLN3X3JQtGu4j3f2Yyfhz+1ZDyaHT/p
	iO5Rf63dth/EAlVb1vB2PI6tmPpX49Pepv3m7qmzuSy3KbEUZyQaajEXFScCAOdI30D3AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsVy+t9jQd0e+zWBBscOsVq8nHCY0eLywkus
	Fve/HmW0mPJnOZPF5V1z2CxOd7Na3NrSxObA7rFz1l12jzvX9rB5zDsZ6NG3ZRWjx/ela9g9
	Pm+SC2CLamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXL
	zAE6RUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYcffeE6aC84IVV/s/
	sjYwfubuYuTkkBAwkfj0ZQMrhC0mceHeerYuRi4OIYHpjBITLp9kAUkICfxilFjyzhHEZhNQ
	k/jy5TA7iC0iYCgx99EZZpAGZoEfjBJbb0xihOhuYJR4NHcXkMPBwSkQLLF7kw1Ig7CAk8TB
	pZuYQGwWAVWJljtLwTbzClhKXFxyDcoWlPgx+R4LSCuzgLrElCm5IGFmAXmJzWveMkMcqiCx
	4+xrRogbrCSWHZ/DAlEjIrHvxTvGCYxCs5BMmoUwaRaSSbOQdCxgZFnFKJpakFxQnJSea6hX
	nJhbXJqXrpecn7uJEZwgnkntYFzZYHGIUYCDUYmHt2P7qkAh1sSy4srcQ4wSHMxKIrzJK1cH
	CvGmJFZWpRblxxeV5qQWH2JMBvpzIrOUaHI+MHnllcQbGpuYGVkamVkYmZibkyasJM57oNU6
	UEggPbEkNTs1tSC1CGYLEwenVANjjkvDv7nWbw2O7LbzD2HIbtljxfA9TDE8cP/Li8afHSQF
	bK4dNs5lKG91jdz5etnNn3vO1x27Ui5xZzHTraIGNbPNJQukZWcJ27Hu257AKX4zVGh5oW7V
	z2tp+dcdd6pIttzaecDPLzzgsl7Kmg2Oa1jY5cUvXtjWGLZi9eSrpf6fWasu9PxSYinOSDTU
	Yi4qTgQA1pjfJFQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 02, 2013 7:51 PM, Andy Shevchenko wrote:
> On Sat, Jun 1, 2013 at 10:13 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> > The usage of strict_strtoul() is not preferred, because
> > strict_strtoul() is obsolete. Thus, kstrtoul() should be
> > used.
> 
> > --- a/drivers/mfd/aat2870-core.c
> > +++ b/drivers/mfd/aat2870-core.c
> > @@ -312,7 +312,7 @@ static ssize_t aat2870_reg_write_file(struct file *file,
> >         while (*start == ' ')
> >                 start++;
> >
> > -       if (strict_strtoul(start, 16, &val))
> > +       if (kstrtoul(start, 16, &val))
> >                 return -EINVAL;
> 
> ret = kstrtoul(...);
> if (ret)
>  return ret;
> 
> > --- a/drivers/mfd/ab3100-core.c
> > +++ b/drivers/mfd/ab3100-core.c
> > @@ -514,13 +514,13 @@ static ssize_t ab3100_get_set_reg(struct file *file,
> >         /*
> >          * Advance pointer to end of string then terminate
> >          * the register string. This is needed to satisfy
> > -        * the strict_strtoul() function.
> > +        * the kstrtoul() function.
> >          */
> >         while ((i < buf_size) && (buf[i] != ' '))
> >                 i++;
> >         buf[i] = '\0';
> >
> > -       err = strict_strtoul(&buf[regp], 16, &user_reg);
> > +       err = kstrtoul(&buf[regp], 16, &user_reg);
> >         if (err)
> >                 return err;
> >         if (user_reg > 0xff)
> 
> user_reg couldn't be more than byte.
> So, you may change its definition to u8 and use here kstrtou8() and
> remove later check.

OK, I will change kstrtoul() to kstrtou8().

Best regards,
Jingoo Han

> 
> But on first glance on that function it could be optimized a lot
> (there are so many custom stuff like skip_space() and like that).
> 
> > @@ -557,7 +557,7 @@ static ssize_t ab3100_get_set_reg(struct file *file,
> >                         i++;
> >                 buf[i] = '\0';
> >
> > -               err = strict_strtoul(&buf[valp], 16, &user_value);
> > +               err = kstrtoul(&buf[valp], 16, &user_value);
> >                 if (err)
> >                         return err;
> >                 if (user_reg > 0xff)
> 
> Same idea here.
> 
> --
> With Best Regards,
> Andy Shevchenko

