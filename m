Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556Ab3EDU4M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 16:56:12 -0400
Received: from nm1.bullet.mail.bf1.yahoo.com ([98.139.212.160]:46627 "HELO
	nm1.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753956Ab3EDU4K convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 16:56:10 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 651122.73803.bm@omp1067.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=uIfY6uZ0R1CXhqA/rrPTuhvsuvRxdaLoniJh4uN0BVUOn/V9SFf+Nm6w/SuWYJzsBQLKcQEjDTe6CZxPpwOOsBKUcHgcMKThsQJlTNQKyiUnAHoHP/3219yjF0kIk4fiD7BBCPN7+50QcSMuoe5d7Y3KIkepomltHYcaQsQbR9c=;
X-YMail-OSG: .YSTWuUVM1kOO3xaxVqlsri6HD1I.ugL_5ALdBi2XTniWST
 JIktp5x47I1f_phy04RRPO6ptWQQo1d9adE92hPlrklc_9uyH6RD0u4JE0vY
 o9aCdLJW5WBVs3tBbuBMpkNCG_YMj2dM2YD891Cr4w8mK2FZOFF5NeaTp7Pd
 6OfY6TqpQ9jIZAYxdDwUaKeavwlyoJABU8vHMeUZv0GIAbADhTePshb_vCvY
 Q2czxZe1ZB4RtCLKoHOqfpfCRbLZf4ZMepvy9m8Qa.G2f.LizV16w.hKsfFl
 .wrjkQRWWj0zFer0Mfb8GLfOeWXRGIGXwLo_M086urjjKa6EHDcGzWPGML7s
 GaATSidLu5c8e15Yyvkujc_el77FeouUO_B9PmnU3WptJRsvqddZ.oiHsK40
 bOj6h3S1rjqCU4PnlM6R1uGQk6ySsqVUx51FPQZEZoeS70TyIhTmxFj0pEqz
 5e.O4y1.mpe1AyAh7iGDXIVMMKyLU4i_UZn7EAmEqUYcpUy7lflKoNlAVaYe
 c0HHZgdxiniTFReUGTLfqWduKxq4lLYRTfIwN2Rhhf8z3o4TuBDhX7junu0F
 mV6Yf_gXlWxQWA_EOhW.FvRGNRfm2iPEvVFw4v5aJ1KMi1iBFHlFPyjp93Al
 44E.51S7OtXXZFPzC.9kKHjlayeYMbAE-
X-Rocket-MIMEInfo: 002.001,QWZ0ZXIgdXBncmFkaW5nIHRvIHRoZSBvZmZpY2lhbCBBcmNoIExpbnV4IDMuOS0yIGtlcm5lbCBwYWNrYWdlLCBkbWVzZyByZXBvcnRzIHRoYXQgbXkgTklDIGlzIGhhbmdpbmc6CgpbIMKgIMKgNS45NTU3MjBdIGUxMDAwZSAwMDAwOjAwOjE5LjAgZW5vMTogY2hhbmdpbmcgTVRVIGZyb20gMTUwMCB0byA0MDAwClsgwqAgwqA4LjQ2NDUwN10gZTEwMDBlIDAwMDA6MDA6MTkuMCBlbm8xOiBEZXRlY3RlZCBIYXJkd2FyZSBVbml0IEhhbmc6CsKgIFRESCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoDwwPgrCoCABMAEBAQE-
X-Mailer: YahooMailWebService/0.8.141.536
Message-ID: <1367700969.8582.YahooMailNeo@web140004.mail.bf1.yahoo.com>
Date: Sat, 4 May 2013 13:56:09 -0700 (PDT)
From: John <da_audiophile@yahoo.com>
Reply-To: John <da_audiophile@yahoo.com>
Subject: 3.9.0 dmesg reports that my NIC is hanging
To: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After upgrading to the official Arch Linux 3.9-2 kernel package, dmesg reports that my NIC is hanging:

[    5.955720] e1000e 0000:00:19.0 eno1: changing MTU from 1500 to 4000
[    8.464507] e1000e 0000:00:19.0 eno1: Detected Hardware Unit Hang:
  TDH                  <0>
  TDT                  <2>
  next_to_use          <2>
  next_to_clean        <0>
buffer_info[next_to_clean]:
  time_stamp           <fffea787>
  next_to_watch        <0>
  jiffies              <fffeaa30>
  next_to_watch.status <0>
MAC Status             <40080080>
PHY Status             <7949>
PHY 1000BASE-T Status  <0>
PHY Extended Status    <3000>
PCI Status             <10>

Not too sure what else to post.  I am not subscribed to lkml so please cc my email in your reply.


Link to complete dmesg: http://pastebin.com/zRBajGrY
Seems similar to: bugzilla.redhat.com/show_bug.cgi?id=785806

