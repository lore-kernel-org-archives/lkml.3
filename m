Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab3LDI1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 03:27:55 -0500
Received: from nm45-vm5.bullet.mail.gq1.yahoo.com ([67.195.87.163]:24816 "HELO
	nm45-vm5.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754383Ab3LDI1x convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 03:27:53 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 226910.55490.bm@omp1031.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=LdzdcoSQEoJbLHADNfhYvUnIecjeF5UEmhY/AcFaZ8bEbMdMT33+vnAI8BM7s+hZpRtaUw5Kx0D1O5/1GYyACHehNIOFctQ6M/znoPNlmugMekJ2e4qFcXoWbDYtns7c111P3whZeTOX1anH5nBW/fUMg4Ofwyl/UJEeoam2H8s=;
X-YMail-OSG: MuBAlaQVM1lpheTxVjv1SXo3h.8QWZJXuBcP47I7QXXJ3HF
 ccclxmkuwd5GxRz3ReAGpewJ2eRvF1cDTk5qpuLGU8GuXhL05B_WEOpxv6..
 a0btjNfRKMV6RCUgBQL_iK3Fa84T.XD1XazSa2AWOiA1JwTGFdwjpNLp7Hfz
 RZv5ypc8jtI07U33qlbm7WWKN0ks4fuuIrcS.ZPksCrjQoEx.uXkkhcGVsma
 CdXDqAUsMAiYtYGNpMphWfePQ.awwom0k88IMoBLxppm_AoIgRxstZQY95Mp
 hdfhsnxHvDHoTl2BW65UhKh7T8Favm9Yep79Z0chGvWg01FUV0Ml0diVRHVR
 WWVVoFsQ325UPR.0I9RmWX9khCoY7tr86bntapuENKZcKMkSoQOmxB.2H82x
 eaFMa8QPX_x9FgL8UZ4WS5hcvxrqIJIAvCCIPhvt6OtQQMYT.tWuDCyMW6GR
 JurlSZ1Dm7iLyf..SwLGobRhTRLd_ERuigW6Px3N9ymzveG1PI5cqnPZRucV
 v8vE3ENGOeqjV3YGmeQDY.9DX.ySXfIYZyJuP025n3r9_gY.xyr7LpOTHChw
 uO7yz3KFE3EGWyZ37pg--
X-Rocket-MIMEInfo: 002.001,SSB0aG91Z2ggaXQgd291bGQgYmUgY29uZmlndXJhYmxlIHNvbWUgd2hlcmUgaW4ga2VybmVsCgoKCgoKT24gV2VkbmVzZGF5LCBEZWNlbWJlciA0LCAyMDEzIDE6MjUgUE0sIFJpY2hhcmQgV2VpbmJlcmdlciA8cmljaGFyZC53ZWluYmVyZ2VyQGdtYWlsLmNvbT4gd3JvdGU6Ck9uIFdlZCwgRGVjIDQsIDIwMTMgYXQgODo0NiBBTSwgU3VraSBCdXJ5YW5pIDxzdWtpYnVyeWFuaUB5YWhvby5jb20.IHdyb3RlOgo.IGhpLAo.Cj4gaSBoYXZlIGZldyBjaGFuZ2VzIGluIG15IG10ZCBwYXJ0aXRpb25zLCBpIHdhbnQBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.167.602
References: <1386143213.75864.YahooMailNeo@web163902.mail.gq1.yahoo.com> <CAFLxGvy55j+6T0jsKwThUdVxSkDWdBErVWE-MW+4ZKwPO-eHrA@mail.gmail.com>
Message-ID: <1386145673.59745.YahooMailNeo@web163904.mail.gq1.yahoo.com>
Date: Wed, 4 Dec 2013 00:27:53 -0800 (PST)
From: Suki Buryani <sukiburyani@yahoo.com>
Reply-To: Suki Buryani <sukiburyani@yahoo.com>
Subject: Re: How to change erasesize of a partition
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "uclinux-dev@uclinux.org" <uclinux-dev@uclinux.org>
In-Reply-To: <CAFLxGvy55j+6T0jsKwThUdVxSkDWdBErVWE-MW+4ZKwPO-eHrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I though it would be configurable some where in kernel





On Wednesday, December 4, 2013 1:25 PM, Richard Weinberger <richard.weinberger@gmail.com> wrote:
On Wed, Dec 4, 2013 at 8:46 AM, Suki Buryani <sukiburyani@yahoo.com> wrote:
> hi,
>
> i have few changes in my mtd partitions, i want to change the erasesize of a partition. can any one tell me where i should look to change erasesize of mtd3...

The erase size is defined by the MTD device, you cannot change it.

-- 
Thanks,
//richard

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

