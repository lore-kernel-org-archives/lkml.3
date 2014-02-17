Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbaBQUT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 15:19:56 -0500
Received: from nm39.bullet.mail.bf1.yahoo.com ([72.30.239.69]:37439 "EHLO
	nm39.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753280AbaBQUTz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 15:19:55 -0500
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Feb 2014 15:19:55 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 76791.65262.bm@omp1036.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=1cPUZ5dDo1+SfcDU0MCzc3irvLhjpm9BGjFdafRQMzHLPGY2YUdJgOdtnEcJy0+sOYyfMfVTChzptKnnOrCGrcv1tAhspHSIRclbAA6+fn0Te8xaPZeBJ6W3pIw+4hC8+mjupZHFtlABCiUmdVV20U3AI1Du5Br4hVePkj85rbQ=;
X-YMail-OSG: 8AYHC.wVM1mXfWroOlaYAbD2ocOsSn1y3jLhl0gZeJGnpgW
 UhF2.DdWsc51pkILAZ2mRIzwsfPBpVcTljGfqeDhDRADY1xwAdo06014wi2P
 vYABDzKgBP0XECUjSFqohCNbGB2S_mZwJU65xAPOxaIN6o02h4dDTQOGXDi_
 q0bY6WOlAWyQyzhBodIeaLd1xjBrxwS4Pw2WeEaNPIIqisG3QefKcKahby_y
 PvzK2CSwULbn7.fzVwEur1v5P5HG07B4i2Rn5f8ypU4WvdokKln0c6qdi9T1
 Ztc0wQ_yb8QNWj1i05YubMxBbguWFCDY.VbL2Lo2xSYaYY6tkMpeeRZTbKX7
 w2wtuehQ.y5u8qfnFRCj9f0OUjdRErBdJzO9VIK3GaXaz74o1OqcT3UvhcLg
 stnMYk1Fy9RIhcMe0z3pJ1nOlkGur5y._YdalymiI_hTCC7GJr0qcq0AnulB
 KiLUPDQx6RVv7UzbL0s2royw1ZqoFCmtAS6dDtT6PVQ_0m7_c7Pzd3lOjqFw
 4PmaggmCTqgVrichwV_ljEMoa441CTUHYuIquizvbdt.y_JoJ2_DlR4dp7sQ
 8nH0bOwPC2lE9OWQ8mV.O
X-Rocket-MIMEInfo: 002.001,CgoKCi0tLS0tIE9yaWdpbmFsIE1lc3NhZ2UgLS0tLS0KPiBGcm9tOiBUcm9uZCBNeWtsZWJ1c3QgPHRyb25kLm15a2xlYnVzdEBwcmltYXJ5ZGF0YS5jb20.Cj4gVG86IEJvcmlzbGF2IFBldGtvdiA8YnBAYWxpZW44LmRlPjsgTGludXggTkZTIE1haWxpbmcgTGlzdCA8bGludXgtbmZzQHZnZXIua2VybmVsLm9yZz4KPiBDYzogSm9obiA8ZGFfYXVkaW9waGlsZUB5YWhvby5jb20.OyBsa21sIDxsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnPjsgIm5ldGRldkB2Z2VyLmtlcm5lbC5vcmciIDxuZXRkZXZAdmcBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.177.636
References: <1392466251.41282.YahooMailNeo@web140003.mail.bf1.yahoo.com>	 <1392494917.71728.YahooMailNeo@web140002.mail.bf1.yahoo.com>	 <20140215203015.GA4528@pd.tnic>	 <1392498262.98385.YahooMailNeo@web140003.mail.bf1.yahoo.com>	 <20140215232508.GB4508@pd.tnic> <1392571653.44773.4.camel@leira.trondhjem.org>
Message-ID: <1392667974.22806.YahooMailNeo@web140003.mail.bf1.yahoo.com>
Date: Mon, 17 Feb 2014 12:12:54 -0800 (PST)
From: John <da_audiophile@yahoo.com>
Reply-To: John <da_audiophile@yahoo.com>
Subject: Re: [BUG] unable to handle kernel NULL pointer dereference
To: Trond Myklebust <trond.myklebust@primarydata.com>,
        Borislav Petkov <bp@alien8.de>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "mlindner@marvell.com" <mlindner@marvell.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
In-Reply-To: <1392571653.44773.4.camel@leira.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





----- Original Message -----
> From: Trond Myklebust <trond.myklebust@primarydata.com>
> To: Borislav Petkov <bp@alien8.de>; Linux NFS Mailing List <linux-nfs@vger.kernel.org>
> Cc: John <da_audiophile@yahoo.com>; lkml <linux-kernel@vger.kernel.org>; "netdev@vger.kernel.org" <netdev@vger.kernel.org>; "stephen@networkplumber.org" <stephen@networkplumber.org>; "mlindner@marvell.com" <mlindner@marvell.com>; J. Bruce Fields <bfields@fieldses.org>
> Sent: Sunday, February 16, 2014 12:27 PM
> Subject: Re: [BUG] unable to handle kernel NULL pointer dereference
> 
> Please ensure that you post to the linux-nfs@vger.kernel.org when
> reporting NFS and RPC related bugs.
>  
> Does the following patch help?
> 


Trond.  Yes, your patch fixes the regression for me; tested on v3.13.3,  I do not know the process by which patches get into the next stable release (minor version).  My hope is that once peer-reviewed, this patch gets into the 3.13.4 and since the 3.12 series is not EOL yet, into 3.12.12 as well.  Thank you for the time and effort!
