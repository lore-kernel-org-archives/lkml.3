Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab3JLXMM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 19:12:12 -0400
Received: from nm32-vm4.bullet.mail.bf1.yahoo.com ([72.30.239.140]:26197 "EHLO
	nm32-vm4.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752800Ab3JLXML convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 19:12:11 -0400
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Oct 2013 19:12:11 EDT
X-Yahoo-Newman-Property: ymail-4
X-Yahoo-Newman-Id: 306002.73735.bm@omp1036.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=hszW+A1X1bB4R4DKjSWlWjy6qFarhY4o8OzL7qzY9dw+fVN6SR2XO6OqgbgFjHNlKcjWOFI8wAvKgToV54W5pV/d1kV691g9Sq8Y+Yb8fdeQIv4HpjtIkvQTlJcnsK9nAHTy2QidYecF4PcVHB5BWIjWLv0+q5Hcfa6COk+yk4Q=;
X-YMail-OSG: Yu8pH1EVM1nmfibZUU0OzqWmdMV9zr0xZWKoTjY6xLqpULQ
 z0wllrE28J9SFMh3hEKFEmRgrZmmjLSteXN.BZw--
X-Rocket-MIMEInfo: 002.001,CgpHcmVldGluZ3MhSSBhbSBuZXcgdG8ga3ZtIGFuZCBhcmUgd3JpdGluZyBhIHB5dGhvbiBzY3JpcHQgdG8gZ2V0IHRoZSBudW1iZXIgb2YgcHJlLWNvcHkgY3ljbGVzIGR1cmluZyBhIHJlbW90ZSB2bSBtaWdyYXRpb24gZ2l2ZW4gbWVtb3J5IHNpemUgTcKgIG9mIGEgVk0gaW4gTUIsIHRoZSBwYWdlIGRpcnR5IHJhdGUgUiBvZiBhIHZtIGluIE1CL3MuIE15IHF1ZXN0aW9uIGlzIG9uIApob3cgdG8gZ2V0IHRoZSBwYWdlIGRpcnR5IHJhdGUuIERvZXMga3ZtIHByb3ZpZGUgYSBkaXJ0eSBwYWdlIApsb2cgZmEBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.160.587
Message-ID: <1381619103.81760.YahooMailNeo@web163102.mail.bf1.yahoo.com>
Date: Sat, 12 Oct 2013 16:05:03 -0700 (PDT)
From: hellen maziku <nahelna@yahoo.com>
Reply-To: hellen maziku <nahelna@yahoo.com>
Subject: KVM Dirty Page Log Facility
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Greetings!I am new to kvm and are writing a python script to get the number of pre-copy cycles during a remote vm migration given memory size M  of a VM in MB, the page dirty rate R of a vm in MB/s. My question is on 
how to get the page dirty rate. Does kvm provide a dirty page 
log facility that provides user space with a bitmap of modified pages 
since the last call? And if yes, please kindly direct me on how to get 
started. I have searched and come across things like

int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log int *is_dirty)

I do not know if this is what I should use and if so how  I could go about to implement it. 

Thank you very much,

