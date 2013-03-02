Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab3CBWpu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 17:45:50 -0500
Received: from nm5.bullet.mail.ird.yahoo.com ([77.238.189.62]:33273 "HELO
	nm5.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751052Ab3CBWpt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 17:45:49 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 615136.71062.bm@omp1043.mail.ir2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=y9u5tJkO9ZBh2RwH4JUywKH0B9RsOTkFrIzxypH10IbZvJ61GngSY/951Hqgb2qJkC7AmLDIKjN4LZW763ulLRAnnXAt2E5tAwgyexeMS893bDowr9oE3qD5E2c6ehFUCZulwFIRPr4JxLpuk2An3goRIRDOM21bTdIIzH5XuUk=;
X-YMail-OSG: MoOJybYVM1nLNhHnJoar0G2aLVXJyR7iOjx8XL4ckrRW80o
 ueDPbz7NpkrCjGkjS5q7R8QDcQK1xd1FUMJ6dmwLGMAao.u.T6LSsLlVP9ir
 jwtIHYPSe65L3h4GZOuvboZGTEbrvGrC_EZnZLGOcpygO3MNwl7Hygl_5si2
 4Aqv8u0WLG16JOa7eDk4HJxlojmQoJsT009ELWJfgC602vMfNS23eIZD6cv0
 kc7PRUcBUrcCnK4t8jMgUmGnwUOt_lsUe5zC4aOvXo1GVyc9E1JuIAseW4CR
 d0bAa8r.mTm7W7jUNcsW4iRMGOoJ9heFd871fM_NxRTZ2qhrHnjJIrKk5M4R
 TCvgYWS7X729vxm5w0t2jWpZqLMC8y7P_EsYQnIqSce3klDmEZBTEyMDVGrQ
 exZQtTLpbaFLPEZAuqzvuZIYBFKts0bCRkycjr8Qt1RvtNZhozPzBLLhxVe7
 zA.wFCVy.HvJxtUu4.D341JJcM6BiB4jK9l2edFc4cYxciTif5nS18fL38Qv
 4yII-
X-Rocket-MIMEInfo: 001.001,SGksCgpJIGp1c3QgcmVhbGl6ZWQgdGhhdCBleHQ0IHNlZW1zIHRvIGNvdW50IGRpc2NhcmRzIG9uIFNTRHMgKGRvbmUgdXNpbmcgZnN0cmltIGNvbW1hbmQpIGFzIHdyaXRlcyBpbiB0aGUgZ2xvYmFsIGZzIHN0YXRpc3RpY3MsIHdoaWNoIGNhbiBiZSB2aWV3ZWQgdXNpbmcgdHVuZTJmcyAtbCAvZGV2L3h4eC4gVGhpcyBpcyBjZXJ0YWlubHkgYSBtaW5vciBwcm9ibGVtLCBidXQgaXMgdGhpcyB0aGUgaW50ZW5kZWQgZXh0NCBiZWhhdmlvdXI_CkJlc3QgcmVnYXJkcywKTWF4ATABAQEB
X-Mailer: YahooMailWebService/0.8.135.514
References: <1362264178.97179.YahooMailNeo@web172003.mail.ir2.yahoo.com>
Message-ID: <1362264347.3893.YahooMailNeo@web172003.mail.ir2.yahoo.com>
Date: Sat, 2 Mar 2013 22:45:47 +0000 (GMT)
From: A B <spinflipper4@yahoo.co.uk>
Reply-To: A B <spinflipper4@yahoo.co.uk>
Subject: ext4 counts SSD discards as writes (output of tune2fs -l /dev/xxx)
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1362264178.97179.YahooMailNeo@web172003.mail.ir2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just realized that ext4 seems to count discards on SSDs (done using fstrim command) as writes in the global fs statistics, which can be viewed using tune2fs -l /dev/xxx. This is certainly a minor problem, but is this the intended ext4 behaviour?
Best regards,
Max
