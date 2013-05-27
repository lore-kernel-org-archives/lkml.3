Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700Ab3E0BCo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 21:02:44 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:62035 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662Ab3E0BCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 21:02:42 -0400
X-AuditID: cbfee691-b7fef6d000002d62-22-51a2b0b1bd2a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Nikolay Balandin'" <nbalandin@dev.rtsoft.ru>,
        "'Devendra Naga'" <devendra.aaru@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 1/1] rtc: rtc-ds1307: use devm_*() functions
Date: Mon, 27 May 2013 10:02:40 +0900
Message-id: <000401ce5a75$e32ffed0$a98ffc70$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5adXINSGALIOzMRCao3fUfVIH2JA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zA92NGxYFGiw/yGux5OJVdos569ew
	WbQfv8hkcXnhJVaLy7vmsFn8f/qc3WJ/ZwejA7vHgmk/mDx2zrrL7rFn4kk2jxMzfrN49G1Z
	xegxfd5PJo/Pm+QC2KO4bFJSczLLUov07RK4Mp40d7EVfOarWNRzkrGB8QBXFyMnh4SAicTH
	Q10sELaYxIV769lAbCGBZYwSk88XwtR8mnecsYuRCyi+iFHi3Nw/zBDOL0aJ1QdvgHWwCahJ
	fPlymB3EFhGIlXi36B5YEbPADkaJA0dfMoMkhAUcJBqP3QVrYBFQlXjytwusgVfAUuLFpDus
	ELagxI/J98BOYhbQkli/8zgThC0vsXnNW2aIkxQkdpx9zQixTE9i379JrBA1IhL7XrwDO1VC
	4B67xO5vO6CWCUh8m3wIaCgHUEJWYtMBqDmSEgdX3GCZwCg2C8nqWUhWz0KyehaSFQsYWVYx
	iqYWJBcUJ6UXmeoVJ+YWl+al6yXn525ihETpxB2M9w9YH2JMBlo/kVlKNDkfGOV5JfGGxmZG
	FqYmpsZG5pZmpAkrifOqt1gHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamA8+Hcb90+BDsbb
	D2Y8YTw7+/faqsoLzx6UR822D9eXSOavUF+t2f7g6uVjK45NfKQrGHG/fdOlQ8z35l4tLLs8
	beFkd2cfw8elWu32zc3TDFNZnKdrul35UZqlz+N/gEPOX8lSONJqkdzdKU63GlOl5nFIi639
	M7mKd1bPm9ntsnKhoufPTxJRYinOSDTUYi4qTgQAhM7hK+gCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jAd2NGxYFGrxYwGmx5OJVdos569ew
	WbQfv8hkcXnhJVaLy7vmsFn8f/qc3WJ/ZwejA7vHgmk/mDx2zrrL7rFn4kk2jxMzfrN49G1Z
	xegxfd5PJo/Pm+QC2KMaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNT
	bZVcfAJ03TJzgC5SUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWY8ae5i
	K/jMV7Go5yRjA+MBri5GTg4JAROJT/OOM0LYYhIX7q1n62Lk4hASWMQocW7uH2YI5xejxOqD
	N9hAqtgE1CS+fDnMDmKLCMRKvFt0D6yIWWAHo8SBoy+ZQRLCAg4SjcfugjWwCKhKPPnbBdbA
	K2Ap8WLSHVYIW1Dix+R7LCA2s4CWxPqdx5kgbHmJzWveMkOcpCCx4+xrRohlehL7/k1ihagR
	kdj34h3jBEaBWUhGzUIyahaSUbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJEZwE
	nkntYFzZYHGIUYCDUYmH98esRYFCrIllxZW5hxglOJiVRHgTooFCvCmJlVWpRfnxRaU5qcWH
	GJOBPp3ILCWanA9MUHkl8YbGJmZGlkZmFkYm5uakCSuJ8x5otQ4UEkhPLEnNTk0tSC2C2cLE
	wSnVwDjp+cNr26wPiiXsbz7KuuZx+t6MaKayLQG686bcnpbjUqK3qjd+ivkz8/USMx3esb89
	oGSxseRs1VEpz1tOAlKuK5ZJas87ZLFrVo7ycRZ7466Kyhy3nnWcd85xRxyWYzbKKz2bVTPD
	WXH5Q73SuJ45Ku4zHK8ZTV9mnRzQcmlHuHlysKrQFCWW4oxEQy3mouJEAEJTiNxGAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, May 25, 2013 10:51 AM, Devendra Naga wrote:
> On Sat, May 25, 2013 at 10:41 AM, Nikolay Balandin wrote:
> > From: Nikolay Balandin <nbalandin@dev.rtsoft.ru>

[.....]

> >
> > -       ds1307->rtc = rtc_device_register(client->name, &client->dev,
> > +       ds1307->rtc = devm_rtc_device_register(&client->dev, client->name,
> >                                 &ds13xx_rtc_ops, THIS_MODULE);

Hi Nikolay Baladin, Devendra Naga,

Here, "devm"_rtc_device_register() is used.
Thus, rtc_device_unregister() will be called after remove() or
on probe failure.


> >         if (IS_ERR(ds1307->rtc)) {
> >                 err = PTR_ERR(ds1307->rtc);
> >                 dev_err(&client->dev,
> >                         "unable to register the class device\n");
> > -               goto exit_free;
> > +               return err;
> >         }

[.....]

> > -exit_nvram:
> > -exit_irq:
> > -       rtc_device_unregister(ds1307->rtc);
>
> Please dont remove this unregister, there's no devm_* for the rtc subsystem.

Above mentioned, rtc_device_unregister() can be removed, because
"devm"_rtc_device_register() was already called.

If I am wrong, please let me know kindly. :)
See you.


Best regards,
Jingoo Han

>
>
> > -exit_free:
> > -       kfree(ds1307);
> > -       return err;
> >  }
> >
> >  static int ds1307_remove(struct i2c_client *client)
> > @@ -992,13 +981,9 @@ static int ds1307_remove(struct i2c_client *client)
> >                 cancel_work_sync(&ds1307->work);
> >         }
> >
> > -       if (test_and_clear_bit(HAS_NVRAM, &ds1307->flags)) {
> > +       if (test_and_clear_bit(HAS_NVRAM, &ds1307->flags))
> >                 sysfs_remove_bin_file(&client->dev.kobj, ds1307->nvram);
> > -               kfree(ds1307->nvram);
> > -       }
> >
> > -       rtc_device_unregister(ds1307->rtc);
>
> Here too.
>
>


