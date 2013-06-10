Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab3FJFvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 01:51:17 -0400
Received: from nm11-vm1.bullet.mail.bf1.yahoo.com ([98.139.213.152]:22355 "EHLO
	nm11-vm1.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751723Ab3FJFvQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 01:51:16 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 556839.20891.bm@omp1034.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=aIdf7NMKYpwdNYMQsZIKPF8VHPtvbJ5L/hkUb4WaS9AOrNIYfMdLwqV/RuHBQgXY1vcpH0NA4XQZFZoA/ZJcuCB8zXvAiYqqv6lR5JWUd20Fr6B1AYpg1XhOope+RQO6wM4VLWUk9NAL3bGCIKlak0TQJukJ7lC+8squoT8JM4A=;
X-YMail-OSG: PYqsxmcVM1logxC6O81QZJsjvJtpArFJ_KF_Yrh2_Pt9.BX
 E9.MTHMr26X4yRxtKTkHi_HaZwkfQux97jIZ_CZSwxRqZxHtTAt5cAt4peE8
 mfhfHdLHVeGAdc5RjDV2nmS2xH7j5XsWyxjvzcKy6_6rEDwgzLOetQEoQh.j
 TTmQb_iptXBmvWqH67Zv1ncsFXtSnvkJA1Ddz_wzj8mbiYSJo0o.CohiLBtM
 KMTZ.pDqSc.x.9xAO_VXukANaUmBm.m0Fvdy.CFVBLpW0FcTod5Bmw.1T00y
 ..LHQE0w1YKPJSRuHTyPcQNbpEXpatDRZ212qJnC4a6BXYryFz70ggBtn7zN
 IneoOGFma59iwYQ2Ee3dACe3ebMXcn82uI_ys61tdpnwre2Wp777qNAt3cH7
 ahZcirG_.Ug0wXI_dI2EYfR__4jyx9w9W3YuI7TTrQQ6TdN.6C01fnubNgY2
 9drXLX_ODh9f.g_zaG0U2thzoLofdT5j8Oyp.f8CaEqtNFFuZI1F4Fb5ynuf
 jj4Lys7EaN0b35KJv.7Q3vKw7mYDwhcHQRc1l2mF3cZocW59uxzuABN.C4JP
 wa6lmGQV3AJJD3QAPO8dB0.1eOLL1Ll1Wv0lMl.zMpH3HhOecQnyyQ_ELe0m
 .nC47f5B90qeM
X-Rocket-MIMEInfo: 002.001,SGksCgpJIHdhbnRlZCB0byBzdWJtaXQgbXkgZmlyc3QgcGF0Y2guCkJ1dCBJIGhhdmUgc29tZSBjb25mdXNpb24gYWJvdXQgdGhlIC9zY3JpcHRzL2NoZWNrcGF0Y2gucGwgZXJyb3JzLgoKQWZ0ZXIgY29ycmVjdGluZyBzb21lIGNoZWNrcGF0Y2ggZXJyb3JzLCB3aGVuIEkgcnVuIGNoZWNrcGF0Y2gucGwsIGl0IHNob3dlZCBtZSAwIGVycm9ycy4KQnV0IHdoZW4gSSBjcmVhdGUgcGF0Y2hlcyBhcmUgZ2l0IGZvcm1hdC1wYXRjaCwgaXQgaXMgc2hvd2luZyBtZSAxIGVycm9yLgoKSWYgSSBmaXggZXJyb3IgaW4BMAEBAQE-
X-Mailer: YahooMailWebService/0.8.146.552
Message-ID: <1370843475.58124.YahooMailNeo@web160106.mail.bf1.yahoo.com>
Date: Sun, 9 Jun 2013 22:51:15 -0700 (PDT)
From: PINTU KUMAR <pintu_agarwal@yahoo.com>
Reply-To: PINTU KUMAR <pintu_agarwal@yahoo.com>
Subject: [checkpatch] - Confusion
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I wanted to submit my first patch.
But I have some confusion about the /scripts/checkpatch.pl errors.

After correcting some checkpatch errors, when I run checkpatch.pl, it showed me 0 errors.
But when I create patches are git format-patch, it is showing me 1 error.

If I fix error in patch, it showed me back again in files.

Now, I am confused which error to fix while submitting patches, the file or the patch errors.

Please provide your opinion.

File: mm/page_alloc.c
Previous file errors:
total: 16 errors, 110 warnings, 6255 lines checked

After fixing errors:
total: 0 errors, 105 warnings, 6255 lines checked


And, after running on patch:
ERROR: need consistent spacing around '*' (ctx:WxV)
#153: FILE: mm/page_alloc.c:5476:
+int min_free_kbytes_sysctl_handler(ctl_table *table, int write,




- Pintu
