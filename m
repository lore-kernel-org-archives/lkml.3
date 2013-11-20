Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab3KTK4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 05:56:44 -0500
Received: from nm46-vm7.bullet.mail.gq1.yahoo.com ([67.195.87.175]:26740 "EHLO
	nm46-vm7.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750855Ab3KTK4l convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 05:56:41 -0500
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Nov 2013 05:56:41 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 905283.21479.bm@omp1067.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=XIM+6XsmpkzNRJBmTHdsBJsXk2mf6m6wV77v42lBAegvb2tMbvbjJIaA5HT15QzO89jyR2MKUrfz/DY6wXZvAKgY35ft4QkaBqgKl4Da56nQFVmGMOuCtsF2sM75U+gp2dTuKsWaoe/T+gMfVFKiApe/PnX5YKwQ9V2BlnvcUmI=;
X-YMail-OSG: doDj2.4VM1lVRor8R61fdtYTBe3Xuxh0NX6DLMKzwXTsFMr
 zMux_Ep0plUkbdNTNZtKJ.L7joX2Mv.kFT0vsN5ppiJVoBmHAgbhZBW556GT
 ThNqQHQN._SoWM.mPCb0kgJCru8HTiZul_ba2D95QOmm.Sm.WfGgaPEICpHW
 d9O3xLCaUPE_0EuScpYJtHNO8X9TOI.0qb3nBH45WpIHuxGJj1AHMXlvU5yl
 03TchRsxUMhM3lycPtvs2PhKr6Tup8945Cp2OyzhTuJDRRXaT8KOpgxPRjd6
 ptr6Zn.6YOBDeBCwU45IJO0XJG76wC5LGFB6uYXTyu7h4zuITtDPbVl0nw0Y
 5hPW1G5R3y3FuKa3TGHzDNuGQqexCa6R8.UXOM1m9sdNe37gOBqdJr24nTvN
 T1i9qy.Uhr3s9l1Dj9ol555DFcNSSbc3UMNwlGsIz.TbFIkRjGCZi01gZKT2
 aowleZz6dtTZ5JfSUyQaKopcqQEOZ3HZ.5maAoN6kixkoaRsbn.ntXjTOydN
 19y1JeFlolwoFXMWGEOhSWczNQphH25b1CeSl2_m5QWx_EVBHj6e58APftVZ
 p9bytFC7XEs7lHgAKBj1WJG31bAoGUI_rfmof
X-Rocket-MIMEInfo: 002.001,PjU4MjQgaXMgdGhlIHVzYWJsZSBzaXplIG9mIHRoZSBmaWxlIHN5c3RlbSBvbiBtdGRibG9jazMsIGkuZS4gYWZ0ZXIgc3VidHJhY3RpbmcKdGhlIG92ZXJoZWFkIGZvciBmaWxlIHN5c3RlbSBib29ra2VlcGluZy4KCgpCeSBkZWZhdWx0IG10ZCBwYXJ0aXRpb25zIHdlcmUgbGlrZQoKY2F0IC9wcm9jL3BhcnRpdGlvbnMKbWFqb3IgbWlub3LCoCAjYmxvY2tzwqAgbmFtZQoKwqAgMzHCoMKgwqDCoCAwwqDCoMKgwqDCoMKgIDgxOTIgbXRkYmxvY2swCsKgIDMxwqDCoMKgwqAgMcKgwqDCoMKgwqDCoMKgIDI1NiABMAEBAQE-
X-Mailer: YahooMailWebService/0.8.166.601
References: <1384934391.56931.YahooMailNeo@web163904.mail.gq1.yahoo.com> <CAMuHMdW-j=FOAo9ZAFFJBiFqBn111Ebng6wTM-t7a3fGhjXsDg@mail.gmail.com>
Message-ID: <1384944598.95627.YahooMailNeo@web163903.mail.gq1.yahoo.com>
Date: Wed, 20 Nov 2013 02:49:58 -0800 (PST)
From: Suki Buryani <sukiburyani@yahoo.com>
Reply-To: Suki Buryani <sukiburyani@yahoo.com>
Subject: Re: Having troubles in updating MTD partitions
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "uclinux-dev@uclinux.org" <uclinux-dev@uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <CAMuHMdW-j=FOAo9ZAFFJBiFqBn111Ebng6wTM-t7a3fGhjXsDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>5824 is the usable size of the file system on mtdblock3, i.e. after subtracting
the overhead for file system bookkeeping.


By default mtd partitions were like

cat /proc/partitions
major minor  #blocks  name

  31     0       8192 mtdblock0
  31     1        256 mtdblock1
  31     2       2048 mtdblock2
  31     3       5824 mtdblock3
  31     4         64 mtdblock4


mtdblock3 was having 5824 blocks and 5824 blocks were able to use,

I think you are missing my point, i have increase size of mtdblock3 but i am unable use whole partion and idk why

kindly also inform me how i can change erasesize of a partition




On Wednesday, November 20, 2013 1:51 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
On Wed, Nov 20, 2013 at 8:59 AM, Suki Buryani <sukiburyani@yahoo.com> wrote:
>   31     3       5884 mtdblock3

5884 is the raw size of mtdblock3.

>  but when i try to use memory relevant tools, it shows me something like
>  # df
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/root                 5824      5824         0 100% /

5824 is the usable size of the file system on mtdblock3, i.e. after subtracting
the overhead for file system bookkeeping.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

