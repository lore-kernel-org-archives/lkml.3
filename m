Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab3KKFsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 00:48:01 -0500
Received: from nm38-vm7.bullet.mail.gq1.yahoo.com ([98.136.217.78]:43074 "EHLO
	nm38-vm7.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752347Ab3KKFry convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 00:47:54 -0500
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Nov 2013 00:47:54 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 280471.45265.bm@omp1042.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=tHmcHED38ztZfT2hE1t4I+RlH78g96KLsHLhh4rMnkcUS1VWz3f6Sc5Lfku2Bq4jv1aASgGlKTwddnhi9+7rkSJoAOO1jV2eIBTK/0D67cKdrj+iYLhD4nY/ga2BNtWhUnJmA3mAs4pw+0fPQ6MQ7cCjW9qbDabpwH8X4fbg8cY=;
X-YMail-OSG: NEVBcuIVM1l139Pcd255G0WVOiEseL6mxBZ0n1BFZFJ8Hri
 _C1_yuG9qOzO27YbIaN9J9Xxt6bcOpfEDtgwP7osZTIOut942YVAa5FwZitL
 cxAdhTYlQaoHTUYAH92B0H_a9mJAKmR5KF2MYJgKqrxFbXa.iBLXpnK0pHrY
 O2Vut_K8PKvE81f2MYTABIyvOrUBY3fveyX9m4_b4tHiKcQ1gZQOSPKY5swA
 MkgtScIHv7EVtRXy1OcdHBOZcwZDEypSYKb.PTaIXPuKgjL0GdSROnL_AovI
 _3xH3641p8AvrFz6llvsbgZnaZBdPWjn0WCdEKb1NLZ5jDFOT7.JK1chyiXc
 ydR6UL67glNsPbdIGVM3t9sKmv8VQ1_M5Kptoa2rgfKLiWXx4hceFq8vPJ7y
 C9zFamfGHPca2eQCAvAxNgeDJkJfuiKweToaXGltvbkB5TtDdMft.H1QJkh2
 Ju.ZZEIXjWne1NsZLNsn4DOtwS5G68aABjT1GMO7ZS8as4qxcyKDkvVkmfo1
 Rhk5nWPbHMXF9zfaOLMM-
X-Rocket-MIMEInfo: 002.001,SGksCgpjYW4gYW55b25lIHRlbGwgbWUsIGhvdyBpIGNhbiBjaGFuZ2Ugc2l6ZSBvZiB0aGVzZSBwYXJ0aXRpb25zPywgYXNwZWNpYWx5IG10ZGJsb2NrMwoKCmNhdCAvcHJvYy9wYXJ0aXRpb25zIAptYWpvciBtaW5vcsKgICNibG9ja3PCoCBuYW1lCgrCoCAzMcKgwqDCoMKgIDDCoMKgwqDCoMKgwqAgODE5MiBtdGRibG9jazAKwqAgMzHCoMKgwqDCoCAxwqDCoMKgwqDCoMKgwqAgMjU2IG10ZGJsb2NrMQrCoCAzMcKgwqDCoMKgIDLCoMKgwqDCoMKgwqAgMjA0OCBtdGRibG9jazIKwqAgMzHCoMKgwqDCoCAzwqABMAEBAQE-
X-Mailer: YahooMailWebService/0.8.163.597
Message-ID: <1384148491.94694.YahooMailNeo@web163901.mail.gq1.yahoo.com>
Date: Sun, 10 Nov 2013 21:41:31 -0800 (PST)
From: Suki Buryani <sukiburyani@yahoo.com>
Reply-To: Suki Buryani <sukiburyani@yahoo.com>
Subject: how to change size of a partition in kernel
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

can anyone tell me, how i can change size of these partitions?, aspecialy mtdblock3


cat /proc/partitions 
major minor  #blocks  name

  31     0       8192 mtdblock0
  31     1        256 mtdblock1
  31     2       2048 mtdblock2
  31     3       5824 mtdblock3
  31     4         64 mtdblock4

my device is running linux-2.6.16,any help would be appreciative

Thanks

