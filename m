Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab3LDHqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 02:46:55 -0500
Received: from nm47-vm9.bullet.mail.gq1.yahoo.com ([67.195.87.187]:31678 "HELO
	nm47-vm9.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753192Ab3LDHqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 02:46:54 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 823558.47567.bm@omp1094.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=hUAft1pv72LTX8+O7A8mc2BgjYvFnkTrh+uRBQfiUzEYMGzLGpT0nbt+yx2j7WF8mHKLtgQn8ZXNaVq8eDw1IMRv84BhcdETfO0FXmbuxMQanNovX2Pf6E/J71U0+mg9YHP5rw+U3L3FvOAfKkTE0m4B8iTJF5sLzH+kwCsxMzE=;
X-YMail-OSG: ygxFBYQVM1m.bTEy11H5eJA4MIMH8OwUnCf8LHvOqpQ.xrc
 KplBy_1o3JGACgAMYE3Wv0PSgWfewSg_MYpZdM_h83TEgcacsj0j3TN.Wz53
 k6wsSBFjvz15oCCIg2k5f7hGrdpe9go9URNY3MtAyhXED6HOX8xcTxpC9Cp2
 RA9etuseL9ZtKhcrAtIHcNoXIdDaFbrEPvzfzZCcWDCs.XIKGHCmPG9lsuJj
 8lhQ1CdsnCyxCNs2tC8ghu_dMGBVHpDnQz8sE.pGapoU6qNHrUUgIkbhBraf
 qSlUafWJYI4_5krNeU4N2O53LdkFnrHI3j6RDSJ3IuZWLJe1uaQDoSNHGKbO
 5Hue7_Tt4y7hcJmtAZASWyC2SNejMWOVP7Y_f5MDHwNSbU4Eu0OaXXWsbLs.
 78TahP8eQZ51KtGOd662kLQWkvJXUR5NsvDq8zQ4f56b6TzlNmDX.dUYyUTs
 OTq4Ir8j5BoTk8UpYJi3BXYJcGh3hefPjmM2IPGXiXj2YV7yurpNjOmPZ8c.
 0VU_J1s85953fILtDtN0-
X-Rocket-MIMEInfo: 002.001,aGksCgppIGhhdmUgZmV3IGNoYW5nZXMgaW4gbXkgbXRkIHBhcnRpdGlvbnMsIGkgd2FudCB0byBjaGFuZ2UgdGhlIGVyYXNlc2l6ZSBvZiBhIHBhcnRpdGlvbi4gY2FuIGFueSBvbmUgdGVsbCBtZSB3aGVyZSBpIHNob3VsZCBsb29rIHRvIGNoYW5nZSBlcmFzZXNpemUgb2YgbXRkMy4uLgoKVGhhbmtzCgEwAQEBAQ--
X-Mailer: YahooMailWebService/0.8.167.602
Message-ID: <1386143213.75864.YahooMailNeo@web163902.mail.gq1.yahoo.com>
Date: Tue, 3 Dec 2013 23:46:53 -0800 (PST)
From: Suki Buryani <sukiburyani@yahoo.com>
Reply-To: Suki Buryani <sukiburyani@yahoo.com>
Subject: How to change erasesize of a partition
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "uclinux-dev@uclinux.org" <uclinux-dev@uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

i have few changes in my mtd partitions, i want to change the erasesize of a partition. can any one tell me where i should look to change erasesize of mtd3...

Thanks

