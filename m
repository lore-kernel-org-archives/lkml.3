Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab3KTIGB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 03:06:01 -0500
Received: from nm39-vm10.bullet.mail.gq1.yahoo.com ([98.136.216.203]:42807
	"EHLO nm39-vm10.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752398Ab3KTIF6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 03:05:58 -0500
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Nov 2013 03:05:58 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 3918.70697.bm@omp1054.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=ZUGyiZLPH2Pr452+kzOIxQI4Mlhjkawq9b7svaCfITgQrPQuAaU7fai/siMN/8oLfgpL1gBA9nI+8udzen/JbLWhklG+WCzFm9ilogcgLbnzWtnNtzYyZoke88WfZpxjwhRxoZH0FZys7ulWLJDGfGD7eU4IEImd6ST6M+LdUmg=;
X-YMail-OSG: iwa3IoMVM1mu_W72ZjGg9DR9bJaQTSTHLWAvqgIUPtE4Vhh
 3VmHh.2KyBjkrR4s1Z.r0ueWdfYjxj8NsY69fWukZqdzerpE2wzoh27YpCy.
 hhJSp9VeUo6ehJcJFieELg0ydRArAY6rco9hcIivb0AvG1PTZL_S5h_qhuxT
 aPKQlkTnk9Lwy42_VgHodjRUrHMRsRKWw4iRVnIXiNHwp9ecmBjRkn.L0wfs
 mlb5r1bPXfS0IIreCGjjv_XBh6IdcqWo4Sm98dCFSEVqgXLA3pBG2c6Narri
 MKOhzBZvAHZa8Q1wwE97c_qJqurslHLi4PLwXUnDkDJD.4587LOX3Jrp9Vnz
 _xyCX9twzRDw0CbjyDhPlvV06Q5L1goZ96kygiKFB7Cdn8JyT7ff_qSZ3Lpx
 OU3tI1YUE2D7eLFXSpPS7P7Im1Df2gGPqF5MLGauiOdK3lPjyp9urB52M6dO
 xuX1LRFAQ0b6Haxx5grnKQPG1AAycckrW278HYeIwxTmlJpk40BsrWwTw3rw
 VD6L5Rjeea1np8l10Zq1pE4Yk
X-Rocket-MIMEInfo: 002.001,aGksCmkgYW0gdHJ5aW5nIHRvIGNoYW5nZSBtdGQgcGFydGl0aW9uIHNpemVzLCBJIGFtIHN1Y2Nlc3NmdWxseSBhYmxlIHRvIGNoYW5nZSBzaXplIG9mIG10ZGJsb2NrIGFzIHUgY2FuIHNlZQoKY2F0IC9wcm9jL3BhcnRpdGlvbnMKbWFqb3IgbWlub3LCoCAjYmxvY2tzwqAgbmFtZQoKwqAgMzHCoMKgwqDCoCAwwqDCoMKgwqDCoMKgIDgxOTIgbXRkYmxvY2swCsKgIDMxwqDCoMKgwqAgMcKgwqDCoMKgwqDCoMKgIDI1NiBtdGRibG9jazEKwqAgMzHCoMKgwqDCoCAywqDCoMKgwqDCoMKgIDIwNDggbXRkYmxvY2sBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.166.601
Message-ID: <1384934391.56931.YahooMailNeo@web163904.mail.gq1.yahoo.com>
Date: Tue, 19 Nov 2013 23:59:51 -0800 (PST)
From: Suki Buryani <sukiburyani@yahoo.com>
Reply-To: Suki Buryani <sukiburyani@yahoo.com>
Subject: Having troubles in updating MTD partitions
To: "uclinux-dev@uclinux.org" <uclinux-dev@uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
i am trying to change mtd partition sizes, I am successfully able to change size of mtdblock as u can see

cat /proc/partitions
major minor  #blocks  name

  31     0       8192 mtdblock0
  31     1        256 mtdblock1
  31     2       2048 mtdblock2
  31     3       5884 mtdblock3
  31     4          4 mtdblock4
  
 but when i try to use memory relevant tools, it shows me something like 
 # df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/root                 5824      5824         0 100% /

5824 was the previous size of mtdblock3

all i have  done is build rootfs with size 5884*1024 and update mtd partition array in kernel, build jffs2 and burn jffs2 in device

there is one more thing, Can any one tell me how i can change eraseblock for a partition, i believe i also having wrong eraseblock for mtdblock3


any help would be appreciative...
thanks

