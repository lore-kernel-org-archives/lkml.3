Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab3HZM3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 08:29:33 -0400
Received: from nm8-vm9.bullet.mail.gq1.yahoo.com ([98.136.218.232]:32909 "EHLO
	nm8-vm9.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756095Ab3HZM3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 08:29:32 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Aug 2013 08:29:32 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 434359.20184.bm@omp1036.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=03aQvK0UverampiQzdAuMjdR/ZmW6PBFdlO9Kj6+A4mNKwbAn4FBzoAJkRS2yWrnIeE/VwUCymCGiUGQ0F4ocmFwkCqfZ6jwIBQlZLfPn8xxHy7j1q4aEdIYopNzCjzOA8AgbLgLFnRJxbmL/t8TAij+mZdB3V4HqlhXqicHNyo=;
X-YMail-OSG: bU74rscVM1kQyZB6269nB1ZgB5vU8mflYkZ0kr.3V4ADS4e
 Hs_.mSMRsIBpbC3kU1tLxVcNvbuRVf0MgIUmE0HVq6qrcVmo1aNO5vWfO0lN
 jpecsrhZ8Zxt6zSqb6_lyA_LDcYX8p1PFdqnf3.ErcM99LgshmauA6_Kv2A.
 910aRgDv9gxtxOXC4eMxWwQ9zEnjmK.WskDT4nLxShgBhMkX3AUPhG79mlZ_
 LcIuwUmWBE5nbgFvk7GlSadWkqBD7FuoyOypCAYPOLi6YPeYshroG5elBzjD
 wZLesAlJbbDRntKczL6SWQ6t6Pbxf_IpRfBUBZlLO2P8CCDf4NScw72JjHxT
 76g2ghuACyQxqHY61NNhFr9MxNsb8FgZkYU_qN9QhxxYM0qsQ2j.0rQS4HN9
 egZdMNSxY4lGc6njmJ4yL3M.Ex6iEkCSGDGFqcJGwH0EaM3ZhGTTeTpe2toh
 7ySHx1djf1jVSGHjwy.EMq0VRuiYm.hVgu2fwzx1En3lHnO2el8Pg3nk70tw
 kqbbzO1ap9oa7RwpoctA-
X-Rocket-MIMEInfo: 002.001,SGksCgpJIHdhbnQgdG8gYWRkIHVwIGEga2VybmVsIG1vZHVsZSB0byBteSBsaW51eCAKa2VybmVsLGN1cnJlbnRseSBpIGFtIG1hbm51bHkgY2hhbmdpbmcgLmNvbmZpZyBmaWxlIHRvIGluY2x1ZGUgbXkgbmV3IAptb2R1bGUgYnV0IGkgd2FudCB0byBhZGQgaXQgYXMgb3B0aW9uIGluIG1lbnVjb25maWcgZnJvbSB3aGVyZSBpIGNob29zZSAKaXQgd2hlcmUgaXQgc2hvdWxkIGJlIGluY2x1ZGVkIG9yIG5vdC4uLgoKVGhhbmtzATABAQEB
X-Mailer: YahooMailWebService/0.8.155.576
Message-ID: <1377519801.80692.YahooMailNeo@web163906.mail.gq1.yahoo.com>
Date: Mon, 26 Aug 2013 05:23:21 -0700 (PDT)
From: Suki Buryani <sukiburyani@yahoo.com>
Reply-To: Suki Buryani <sukiburyani@yahoo.com>
Subject: how to make a option in menuconfig as new feature
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I want to add up a kernel module to my linux 
kernel,currently i am mannuly changing .config file to include my new 
module but i want to add it as option in menuconfig from where i choose 
it where it should be included or not...

Thanks
