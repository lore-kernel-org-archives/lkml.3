Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081Ab3LHXnP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 18:43:15 -0500
Received: from nm9-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.154]:34311 "HELO
	nm9-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755574Ab3LHXnN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 18:43:13 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 787012.68817.bm@omp1023.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:Message-ID:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=A8HCmHUUkBfiSq9MXCspczNROE4EsqJgwzllYPqBUpvJ+JHNdWP19jSji7nVuQhIYPnxkXjwJ8SUXxctg7i5LqFKIymSBPy/+MdhxLemN0jdC7n3CH4rq3vm8D8BuIbd//zaTCZBqXBj5EMwfjGTVfMUy3wdAlSei+/Vo7WLIC4=;
X-YMail-OSG: 1wpTLNEVM1mFDPX8NY2w3tcxnfxPz09WLdXmguTZI3Duq7d
 a9nhjtqjkQjFjQ9mMrDovqtMJjABi9v.M7FlB9.PCLyIdsMSMlzTJu.f8KYA
 rBIr1Kc12XJkS8ZleaXYRPl3tAPoKt9CP3o2UWd0CdjxcNWTnga_lW0z8xO0
 .DDs1tDkHsEF7MPwVhteqbJC53.Pd9rLesooem9OcI7WUahzYSXTmdb4yHII
 Il1Zc1WFXq2cQGReUdToLUb5vW6d6PTFwOumk3zIthbFXvTr8nI_UqvfzvVF
 VkzQHO8phonZWrDdnLdkfdsJJrP4OQiGeyKQxlNrOpQBzNpuAhGZtXDOx6bk
 HJZEGipq3n2KI.g0ygngURnDqO9wWLK.3YjzjN6fztStFhj1VQjIFD2AbRZ.
 8vV6jIsmwpIqScylfVkvq8KemDN.3druLrVxwX_lkTXJ5_lPe6JWB.aYojtL
 l6Uoboe5Fw3mnv2XNB9e8lw0UI1USFHdlIhCU_BcQni_fRHvy2t6S4vOGI_B
 kshnuNaIXH9a2iG_SFxiFbIEQD8IKFlU8V5NAkm7nnnV21YblhZxlbL2ibZu
 PSIxb1RyM.Q--
X-Rocket-MIMEInfo: 002.001,DQpJIGNvZGUsIHRoZXJlZm9yZSBJIGFtDQoNCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQpPbiBTdW4sIDEyLzgvMTMsIEFsZXggRGF2aXMgPGFsZXgxNDY0MUB5YWhvby5jb20.IHdyb3RlOg0KDQogU3ViamVjdDogUmU6IFtQQVRDSF0gZGVsbC1sYXB0b3A6IGFkZCBwYXJhbWV0ZXIgdG8gZGlzYWJsZSB0aGUgYmFja2xpZ2h0IGRldmljZS4NCiBUbzogIm1qZzU5QHNyY2YudWNhbS5vcmciIDxtamc1OUBzcmNmLnVjYW0ub3JnPiwgImxpbnV4LWtlcm5lbEB2Z2VyLmtlcm4BMAEBAQE-
X-Mailer: YahooMailClassic/379 YahooMailWebService/0.8.169.609
Message-ID: <1386546191.74980.YahooMailBasic@web160402.mail.bf1.yahoo.com>
Date: Sun, 8 Dec 2013 15:43:11 -0800 (PST)
From: Alex Davis <alex14641@yahoo.com>
Subject: Re: [PATCH] dell-laptop: add parameter to disable the backlight device.
To: "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Levente Kurusa <levex@linux.com>
In-Reply-To: <1386535096.90326.YahooMailBasic@web160402.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I code, therefore I am

--------------------------------------------
On Sun, 12/8/13, Alex Davis <alex14641@yahoo.com> wrote:

 Subject: Re: [PATCH] dell-laptop: add parameter to disable the backlight device.
 To: "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Levente Kurusa" <levex@linux.com>
 Date: Sunday, December 8, 2013, 3:38 PM
 
 
 
 --------------------------------------------
 On Sun, 12/8/13, Levente Kurusa <levex@linux.com>
 wrote:
 
 > Subject: Re: [PATCH] dell-laptop: add parameter to
 disable the backlight device.
 > To: "Alex Davis" <alex14641@yahoo.com>,
 "mjg59@srcf.ucam.org"
 <mjg59@srcf.ucam.org>,
 >"linux->kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>
 > Date: Sunday, December 8, 2013, 9:06 AM
  
  
  >>2013-12-08 14:40, Alex Davis:
  >> I have a Dell Inspiron N7010 Laptop with Intel
  graphics. When the dell-laptop module is loaded,
  >> two backlight device devices are created;
  dell_backlight, and intel_backlight from the Intel
  >> graphics driver. The dell_backlight device is
  non-functional, but the graphics subsystem uses
  >> it instead of the functioning intel_backlight
 device.
  The result is that, when running KDE,
  >> screen brightness cannot be controlled. I've added
 a
  module parameter, disable_backlight
  >> which, when true, will disable the dell_backlight
  device, and leave only the intel_backlight:
  >> with this, screen brightness can be controlled.
  >> 
  
 > Hi,
  
  >I think it would be better if we could figure out why
 the
  >dell_blacklight device is not working rather than
 disabling
  >it.
  
  
 > Regarding your patch, it creates a memory leak as you:
 >  * allocate a platform device
 >  * you add it
 >  * you allocated a page for SMI
 > 
 > Your if(disable_blacklight) code should go
 > where it checks the DMI.
 > 
 > -- Regards,
 > Levente Kurusa
 
 Levante,
 
 >You are correct. The existing code also has a memory leak. I
 >will submit a patch for that.
 
Upon further investigation, I'm not seeing the memory leak. I see the objects being allocated, but they are deallocated in the dell_exit method. 
 
  
 
