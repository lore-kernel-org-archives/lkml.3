Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759957Ab3LHUoR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 15:44:17 -0500
Received: from nm50-vm2.bullet.mail.bf1.yahoo.com ([216.109.115.221]:31788
	"HELO nm50-vm2.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755274Ab3LHUoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 15:44:16 -0500
X-Greylist: delayed 358 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Dec 2013 15:44:15 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 611192.55478.bm@omp1016.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:Message-ID:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type;
  b=hy6IGMVhtC5YpU+bq+9A5+bXSDbLwyJYkTRQFfjZjp7wO+rSESCeOtaJywC5BQr0EUXzNLaYDbCAxfpJm+DshVgJFkiUPwwjkC6Hu8axHnGxk76Vt0jtPcLpPXIgTl52XRt2ywkWZL3BPQ464rN+jwP1FBVjlhLUOfunDnW2c6U=;
X-YMail-OSG: jyKgO0QVM1ndvnZcSYUO_ks4AJPOe.8GJj0KaZaYy9YOgEB
 rUIErtbCmVonkf0MQDbDf_l4o.1O4rdhplFZikpB0e6dYT.RFC1Yplzc44EQ
 aaTBBItLPxyxBrlxB_a29b1K_7TOdDYZ3FddIk4Xz.DA7djF9felq3pD5FhP
 CVNrzoeINPXf_.xo48DsT6qFryor7q.F84qUMCISNejH.LlpMRDrx3llKI6p
 jJJQ2Qr5BxGzebP_KbhBOj5otxXUdLLVhWgszQbhP.MyzhfPe1aabyLHrMFB
 q9w8gnfyVoaWiPZ410lHDNdkBtMtitKnY6CDMV0SiI0nhFuOGJlC5Mf4CymN
 1gvn7u_XSxn8FCzE2xUyuIYs_gx_8PgocusXxMGD7Wd7IvW2JOLBPAsMxN9c
 8W_a9__npj.SND356NNDFl59Tr1TSLG3LMFWdcVz.ugOthlcpFSvv8ptRVwl
 vKAB3KUShA4x8N07FCIwjnPNOVSESGEBeAVD0QDZHkf4roDPe6S3R0VkUZR7
 hwVLRo68GmdtB4hXd0q9PbCZAiW3ykgF.Ejb8fyRTZvhR0VdaQ8AVKJQnwsy
 hPWRo7tk_myw-
X-Rocket-MIMEInfo: 002.001,DQoNCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQpPbiBTdW4sIDEyLzgvMTMsIExldmVudGUgS3VydXNhIDxsZXZleEBsaW51eC5jb20.IHdyb3RlOg0KDQo.IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIGRlbGwtbGFwdG9wOiBhZGQgcGFyYW1ldGVyIHRvIGRpc2FibGUgdGhlIGJhY2tsaWdodCBkZXZpY2UuDQo.IFRvOiAiQWxleCBEYXZpcyIgPGFsZXgxNDY0MUB5YWhvby5jb20.LCAibWpnNTlAc3JjZi51Y2FtLm9yZyIgPG1qZzU5QHNyY2YudWNhbS5vcmc.LCA.ImxpbnV4LT4BMAEBAQE-
X-Mailer: YahooMailClassic/379 YahooMailWebService/0.8.169.609
Message-ID: <1386535096.90326.YahooMailBasic@web160402.mail.bf1.yahoo.com>
Date: Sun, 8 Dec 2013 12:38:16 -0800 (PST)
From: Alex Davis <alex14641@yahoo.com>
Subject: Re: [PATCH] dell-laptop: add parameter to disable the backlight device.
To: "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Levente Kurusa <levex@linux.com>
In-Reply-To: <52A47CCC.50000@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--------------------------------------------
On Sun, 12/8/13, Levente Kurusa <levex@linux.com> wrote:

> Subject: Re: [PATCH] dell-laptop: add parameter to disable the backlight device.
> To: "Alex Davis" <alex14641@yahoo.com>, "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>, >"linux->kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
> Date: Sunday, December 8, 2013, 9:06 AM
 
 
 >>2013-12-08 14:40, Alex Davis:
 >> I have a Dell Inspiron N7010 Laptop with Intel
 graphics. When the dell-laptop module is loaded,
 >> two backlight device devices are created;
 dell_backlight, and intel_backlight from the Intel
 >> graphics driver. The dell_backlight device is
 non-functional, but the graphics subsystem uses
 >> it instead of the functioning intel_backlight device.
 The result is that, when running KDE,
 >> screen brightness cannot be controlled. I've added a
 module parameter, disable_backlight
 >> which, when true, will disable the dell_backlight
 device, and leave only the intel_backlight:
 >> with this, screen brightness can be controlled.
 >> 
 
> Hi,
 
 >I think it would be better if we could figure out why the
 >dell_blacklight device is not working rather than disabling
 >it.
 
 
> Regarding your patch, it creates a memory leak as you:
>  * allocate a platform device
>  * you add it
>  * you allocated a page for SMI
> 
> Your if(disable_blacklight) code should go
> where it checks the DMI.
> 
> -- Regards,
> Levente Kurusa

Levante,

You are correct. The existing code also has a memory leak. I will submit a patch for that.


 
