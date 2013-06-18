Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab3FRIqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:46:35 -0400
Received: from nm41-vm1.bullet.mail.gq1.yahoo.com ([67.195.87.88]:32593 "EHLO
	nm41-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754907Ab3FRIqa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:46:30 -0400
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Jun 2013 04:46:30 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 427499.49006.bm@omp1061.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=YvU9Tn+BeiQhLt6F91qCKvF2qxQCVIfvvY4mSlaSDGPFJc9Nz2E/FcEeHBC0Lpw3oTFMd4+0B3uGihP6uao8qsNx0E7Ua7zwkFOGxcztRqchU0wJM8vTf6nMtie+yUw45eON6lSuk/dADcwyCjGyLH0uwY1Cd8Y9WZsjPYbfiok=;
X-YMail-OSG: RKo06WgVM1lTCxRQ.AAXdgRfBk3vPCxklyKVCPAISX6zRQR
 t5RKkcDl8C9PfUGMc5gYqX5mlJG4a0VCO3GAw35UibT0_LxC2r2mYklIi5Ok
 QPJX.oyFraSdhbSKxkp44VI3fx.u5I5cqzKlcE.OCVRADHizDCm1vLyvzLQq
 uW_Ql9YABERYMB5wZTL5TBTEz0dyLTdY3fJv3sQ6vP6oGRHwuLmwOo9mq0Ld
 u.upq181VqoL6DsQE4nJYmw5XIxDFu1QWpgpCuq.30Kk3APQAFayzpg0UDIy
 YKb7qHt1eMsQbYyKu1WsD3pTSOqc_W.1L6Ul9kGs5o0ZzdS_mCOq1g0YWWcL
 5q31OPcxaEDDqCWItGA_JxU0jANy3JgOkUSeC_W.xHaviubdoeyMe7bLix5j
 2CnDN_rHOJsba4FkkRjKM2nroR4DsyMRVp085FnIxaW6HWUgGs.ff3zfzqBE
 TDbk62RCCRUFButl.hihdFfgH7E5ertmZAJVL4u_ZGPZMYLHv3.ZISP7klB0
 a
X-Rocket-MIMEInfo: 002.001,CgpoaSwgCgppIGFtIGFsbW9zdCBmcmVzaCBpbiBlbWJlZGRlZCBMaW51eCwgaSAKd2FudCB0byB0ZXN0IExERDMgZXhhbXBsZXMsIGZvciB0aGF0IGkgaW5zdGFsbCBmZWRvcmEgNCBpbiBteSBWTSwgaSBhbSAKdW5hYmxlIHRvIGNvbXBpbGUgdGhlIGtlcm5lbCwgaSBoYXZlIHNldCBjb25maWdzIHVzaW5nIG1ha2UgbWVudWNvbmZpZywgCmFuZCB0aGVuIHRyeSB0byBtYWtlIGNvbXBpbGUgYnV0IGl0IGdpdmVzIG1lwqAgZXJyb3JzIGxpa2UKCltyb290QGxvY2FsaG9zdCAyLjYuMTEtMS4xMzY5X0ZDNC1pNjgBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.147.553
Message-ID: <1371544794.13366.YahooMailNeo@web163905.mail.gq1.yahoo.com>
Date: Tue, 18 Jun 2013 01:39:54 -0700 (PDT)
From: Suki Buryani <sukiburyani@yahoo.com>
Reply-To: Suki Buryani <sukiburyani@yahoo.com>
Subject: Need to Test lld3 examples
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



hi, 

i am almost fresh in embedded Linux, i 
want to test LDD3 examples, for that i install fedora 4 in my VM, i am 
unable to compile the kernel, i have set configs using make menuconfig, 
and then try to make compile but it gives me  errors like

[root@localhost 2.6.11-1.1369_FC4-i686]# make
  CHK     include/linux/version.h
scripts/kconfig/conf -s arch/i386/Kconfig
#
# using defaults found in .config
#
  SPLIT   include/linux/autoconf.h -> include/config/*
  CHK     include/asm-i386/asm_offsets.h
  CC      scripts/mod/empty.o
  MKELF   scripts/mod/elfconfig.h
  HOSTCC  scripts/mod/file2alias.o
  HOSTCC  scripts/mod/modpost.o
  HOSTCC  scripts/mod/sumversion.o
scripts/mod/sumversion.c: In function 'parse_file':
scripts/mod/sumversion.c:260: warning: pointer targets in passing argument 1 of 'grab_file' differ in signedness
scripts/mod/sumversion.c:277: warning: pointer targets in passing argument 1 of 'parse_string' differ in signedness
scripts/mod/sumversion.c:283: warning: pointer targets in passing argument 1 of 'parse_comment' differ in signedness
scripts/mod/sumversion.c: In function 'parse_source_files':
scripts/mod/sumversion.c:335: warning: pointer targets in initialization differ in signedness
scripts/mod/sumversion.c:344: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
scripts/mod/sumversion.c:357: warning: pointer targets in passing argument 1 of 'parse_file' differ in signedness
scripts/mod/sumversion.c: In function 'strip_rcs_crap':
scripts/mod/sumversion.c:465: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
scripts/mod/sumversion.c:465: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
scripts/mod/sumversion.c:465: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
scripts/mod/sumversion.c:465: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
scripts/mod/sumversion.c:465: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
scripts/mod/sumversion.c:465: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
scripts/mod/sumversion.c:465: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
scripts/mod/sumversion.c:465: warning: pointer targets in passing argument 1 of 'strncmp' differ in signedness
scripts/mod/sumversion.c:469: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
scripts/mod/sumversion.c:469: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
scripts/mod/sumversion.c:469: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
scripts/mod/sumversion.c:485: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
scripts/mod/sumversion.c:486: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
scripts/mod/sumversion.c: In function 'maybe_frob_rcs_version':
scripts/mod/sumversion.c:496: warning: pointer targets in passing argument 1 of 'strip_rcs_crap' differ in signedness
  HOSTLD  scripts/mod/modpost
make[1]: *** No rule to make target `init/main.o', needed by `init/built-in.o'.  Stop.
make: *** [init] Error 2


could somebody inform me i could be missing, or where i can test LDD3 examples with zero defects

Thanks
