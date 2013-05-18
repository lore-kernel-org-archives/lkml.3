Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639Ab3ERNcQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 09:32:16 -0400
Received: from nm35-vm0.bullet.mail.bf1.yahoo.com ([72.30.238.72]:38506 "EHLO
	nm35-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751313Ab3ERNcO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 09:32:14 -0400
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 May 2013 09:32:14 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 63513.90108.bm@omp1058.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=d+cPcOAmnfGpU0tqw+eu1OU9xMJSnCXMsqU111anrXiTdifagqXGJWSImhsMHljns7+gWmjMPNMMRRohnqE/f2GsBaOfhRwID5iLWov13Qp8VqFfXiCiXnE8IHcQHs6+pmR29FZL04V7kcr39Ds8rX9DOdp701JSAvHrLW4N7MM=;
X-YMail-OSG: rKqkQuIVM1mdDJTHghlTSfA24RucGxEqEa_emfDDVG65Nbs
 lRjElS33OV3RilzoIMf8yCBZhE6i8l0.3f9WKLPEahljWpBbRXbFE0.L5Fvl
 n.1Vwq7GiRXCWHEGpcso673QKbgL4a46qdxbdgRLYxrpoKqXBWooMlCaFU_F
 iF5l3FeL9JusLHYflUqB.jHVZShLPSLqIWk.T9yEWtYkex5AvZph9VBxmCJj
 NxgX9DB2qhaa6Ib4_DsIiIWQiMORyNZapZO6NiEC67HuPXybTl5rr4SM2H.c
 R.9Lrh7xe8797xRKN28joer7M6oDFDZiJivfN5z1hEY8vbypIGEB_WTodZJt
 r4D7qWjtQ2I33RECCKpCWF._64S.rwpistf3kbKOkgl8JaidNPee.90zSTPB
 rcdGag9.ZKm2FttCqwhoqUrKZW765mEAJGlbVrUKXfQ5KDwmI2bas_83q9vt
 VQ95yJ7o.e1KI4Nva48W76.JA.TR5viAUXhst9HfZ2zA_GkZ5_E9HlWoxbBf
 6vavmDzXAWQfFbAW_Z4I-
X-Rocket-MIMEInfo: 002.001,CkhlbGxvLApSZWNlbnRseSBJIGhhdmUgZGV0ZWN0ZWQgYW4gSVAgY29uZmxpY3Qgd2hpbGUgbXkgT1MgaXMgcmVkaGF0LgogU2VhcmNoaW5nIGZvciBhIHNvbHV0aW9uIHJldmVhbGVkIHRoYXQgbGludXgga2VybmVsIGRvZXNuJ3QgcmVwbHkgdG8gCmJyb2FkY2FzdCBhcnAgbWVzc2FnZXMgKmF0IGFsbCouIEFzIGEgcmVzdWx0IHdoZW4gc29tZW9uZSBhc2tzICJ3aG8gaGFzIAppcCBBLkIuQy5EPyIsIG15IGtlcm5lbCB3b24ndCByZXBseSB0byB0aGF0IGFuZCB0aGUgb3RoZXIgaG9zdCB0aGlua3Mgbm8KIG8BMAEBAQE-
X-Mailer: YahooMailWebService/0.8.142.542
Message-ID: <1368883527.64562.YahooMailNeo@web163002.mail.bf1.yahoo.com>
Date: Sat, 18 May 2013 06:25:27 -0700 (PDT)
From: Mahmood Naderan <nt_mahmood@yahoo.com>
Reply-To: Mahmood Naderan <nt_mahmood@yahoo.com>
Subject: broadcast arp messages and linux kernel
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,
Recently I have detected an IP conflict while my OS is redhat.
 Searching for a solution revealed that linux kernel doesn't reply to 
broadcast arp messages *at all*. As a result when someone asks "who has 
ip A.B.C.D?", my kernel won't reply to that and the other host thinks no
 one has that IP so there will be a conflict.

I also searched a lot to find why kernel won't reply to that but didn't find a clear answer.
Don't you think kernel should reply to those messages?

 
Regards,
Mahmood

