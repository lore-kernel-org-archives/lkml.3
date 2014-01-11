Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbaAKEOY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 23:14:24 -0500
Received: from nm43-vm1.bullet.mail.gq1.yahoo.com ([67.195.87.216]:28827 "EHLO
	nm43-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751343AbaAKEOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 23:14:20 -0500
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Jan 2014 23:14:20 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 288545.93990.bm@omp1056.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=CSmipdHu9O3cGSiWWAoBVUs8qk1mauzCvZ7vUZaNl/9E1zaL7HttmUvxSreA0Z67e0FvebD6JnxMNod8Ug89J+0T12GDqFRQI1/pI2cA+SzrGFKkxaueGQd5Bp3mbaygU2JFYcI7D/pWcEMRDgsOggxDBXnm0dI3WApO5esF5zU=;
X-YMail-OSG: jiI40PsVM1npPg47h.UbtKQOHMsHEFC1JoLemxA8lrLb3JS
 Mrqma7uF7tjWhl1zmNwbQ6fgshWz5EJvcApJ_gW0v0XqqdqLczuXL4fd.oC6
 01yi_LVa196wV.xhEnMBydyf7aKALV3kDXogrxFfXIsTfvxx8DlK7hOmEY76
 dythKqtzILj0aExPvGBxjQyscB4JUc_ncKjaKq.S1WwJXHZJCktWdwsXoL3o
 orgt9ub.kSk.XA9d7xmaivJ21hFrs6pVj_6Su0PhfH7y23Pgtuu.ry3QrZix
 BlPgdhfx8yqMJ9jwsYpS_EAa6gNV6byEq.WXealR10MxKZ0IYzw_XJKB8Vr7
 PCgPvib..OrTFi_n48AZlSRaE7FTv5jHdbsn.SZkqMa9FsDUQZZ5B8u1O3Kx
 1gu609EETJR6CKkOYCKRh3rrQvF92bB.lnZlADVaFFc7ml1sRhfd6Q_0M8o9
 0P6EWFse3mg_b8KgbNtT8DjHcNjIL0rcAaR9ILPFRpUh3Hrm6rqx_Ye_omV.
 f_ZYTfmj1pOeWUuNYmmzcEjCSANdn7X9p89OVOxF46xgVU2y3aFI2VHKTBXz
 ubg4khgWSZrJTpUMmB0U5CEXrIVG0rsJaD.W.FT9ZS15xfxlfMNph6uc8ISG
 Xb3EmU8i.cg--
X-Rocket-MIMEInfo: 002.001,VGhpcyBwYXRjaCBzZXJpZXMgZml4ZXMgc2V2ZXJhbCB3YXJuaW5ncyByZXBvcnRlZCBieSBjaGVja3BhdGNoLnBsIGluIG5pX21pb19jb21tb24uYyBvZiB0aGUgY29tZWRpIGRyaXZlci4KCkFtb25nIHRoZSBpc3N1ZXMgZml4ZWQ6CipNYW55IHVubmVjZXNzYXJ5IGJyYWNlcyBoYXZlIGJlZW4gcmVtb3ZlZC4KKkltcHJvcGVyIGluZGVudGF0aW9uIGhhcyBiZWVuIGNvcnJlY3RlZC4KKkV4dHJhIHdoaXRlc3BhY2UgYmVmb3JlIHNlbWljb2xvbnMgaGFzIGJlZW4gcmVtb3ZlZC4KKkV4dHJhIHdoaXRlc3BhY2UBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.172.614
Message-ID: <1389413226.84382.YahooMailNeo@web164002.mail.gq1.yahoo.com>
Date: Fri, 10 Jan 2014 20:07:06 -0800 (PST)
From: Chase Southwood <chase.southwood@yahoo.com>
Reply-To: Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH 0/3] Staging: comedi: Checkpatch cleanups in ni_mio_common.c
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes several warnings reported by checkpatch.pl in ni_mio_common.c of the comedi driver.

Among the issues fixed:
*Many unnecessary braces have been removed.
*Improper indentation has been corrected.
*Extra whitespace before semicolons has been removed.
*Extra whitespace after function pointer name has been removed.

Several checkpatch warnings still remain (mainly 80 character+ line lengths), but no new warnings have been introduced, and no functionality changes have been made.
