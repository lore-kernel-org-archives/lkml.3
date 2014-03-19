Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933119AbaCSJ5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 05:57:30 -0400
Received: from nm3-vm0.bullet.mail.bf1.yahoo.com ([98.139.212.154]:31140 "EHLO
	nm3-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757582AbaCSJ51 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 05:57:27 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 557813.48591.bm@omp1056.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=ria7pw9f2q/S+NkwFbh5Tp8tg1xveGyci43otqIrGUrxRh5QkeKmvDtUKB1mFSQa1YZQaTYtT7Fe/V1H+K1X2h6MqeGg9RH+2YJnGR4SZDLi+ojMc40HWKIAYSdDjhoBnahN9ZkNhgwAnLlYxnLhTDyFl+eVnv48pu/RyWJ1zmc=;
X-YMail-OSG: ujXlhkMVM1kDUDTnqNAbA92zHadT2TE45PB22I1bo0Kb.Wk
 CNbRqM5Ggscof5c6EiLdBYarkXz5uKdrArd9MeL4X3doJsEhZkHNT8fOj1oA
 E7Ng3MlgUzH2UwlYN11rdEUzmqpOcjbctzJ_5PLIsGBKibBjrCX9ZEHGHOf5
 1l860NWoBd5tmT1qtsbOvvq.930s2W5mKli6DfMSehoPiTqp.YRxCQwDj3mG
 xnnP.AyKS6ZtTs7MkBuynMdSMuGiHSaA3oCLEC_hansZ0_ONVM2Qb6kZL1gK
 TaD9NB93AFrDOKMHwJj79vQKiix_ibI0PpanVp0jbrQd2DR05D7CRq8vBWg5
 aXTj8Cn3Wrv7uef8aqiH1gU_mKPFqwSzMwwzgoiINYGdOw42U6818UIZCF6.
 BPQWshFQ9Y3Cv8n6gkybl530s8xCBsb1cOgXrhMsBGfvTURYMWbzCOhYpu.e
 kiuIXgHE0CnYat0jeZrwLHNOIQls0hLBTEe42YiqYVQY3GOByGqBHFnPQEGl
 BAjqS5cAhDi3F6YO9Q5MHk57tVYWy4scDMisp_jUoDmQV09e8WNtw01oxPzk
 LUZc7Ggr9UGuZ9j_Bm4J4xViYrIKboW7l23TO
X-Rocket-MIMEInfo: 002.001,CgpIaQpNYXliZSB0aGlzIGlzIGEgbm9vYiBxdWVzdGlvbi4uLgpXaGVyZSBpbiB0aGUgbGludXgga2VybmVsIHNvdXJjZSAoMi42KSwgdGhlIAoKdGhyZWFkIHNjaGVkdWxlciBoYXMgYmVlbiBpbXBsZW1lbnRlZD8gU2VhcmNoaW5nIAoKdGhlIHdlYiBzaG93cyB0aGF0IHRoZXJlIHNob3VsZCBzY2hlZF9mYWlyLmMgYnV0IAoKSSBjYW4gbm90IGZpbmQgdGhhdCBpbiB0aGUgc291cmNlIGRpcmVjdG9yeSAodGhlIAprZXJuZWwgc291cmNlIGhhcyBiZWVuIGluc3RhbGxlZCkuIAoKCkJhc2ljYWxseSwgSSB3YW4BMAEBAQE-
X-Mailer: YahooMailWebService/0.8.178.641
Message-ID: <1395223046.28757.YahooMailNeo@web141601.mail.bf1.yahoo.com>
Date: Wed, 19 Mar 2014 02:57:26 -0700 (PDT)
From: Mahmood Naderan <nt_mahmood@yahoo.com>
Reply-To: Mahmood Naderan <nt_mahmood@yahoo.com>
Subject: Thread Scheduler
To: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi
Maybe this is a noob question...
Where in the linux kernel source (2.6), the 

thread scheduler has been implemented? Searching 

the web shows that there should sched_fair.c but 

I can not find that in the source directory (the 
kernel source has been installed). 


Basically, I want to know which part of the code 

calculated the priorities of the available 

threads and select them for running?


Regards,
Mahmood 
