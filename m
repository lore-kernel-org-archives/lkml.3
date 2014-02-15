Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbaBOVHY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 16:07:24 -0500
Received: from nm33.bullet.mail.ne1.yahoo.com ([98.138.229.26]:46605 "EHLO
	nm33.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752965AbaBOVHW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 16:07:22 -0500
X-Yahoo-Newman-Property: ymail-4
X-Yahoo-Newman-Id: 687079.35607.bm@omp1052.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=jmNR7GvrUTqw0hd4P/98+EEhjL7HgndOaHSyntBjTpLtSFFyyYk30YZf+WYAfK3YifRAJNjQ9DKXxBzebfJXaCpztqNAkAp3F2xfDNuq69FptnFxvjkUAjKa9jNZS01rvmHa1weWqyF/ru5qJ+gzP6PN6G2NuvHUbhgZ6WZHxIs=;
X-YMail-OSG: vaffhaAVM1kZ8ebvAH26116A2Jh3zLkKS8oJA5zynZEsSlG
 sP_ZtMoBK.O5bjsm7QErzlURA37_USaov_1jey1LOULbd9w--
X-Rocket-MIMEInfo: 002.001,CgotLS0tLSBPcmlnaW5hbCBNZXNzYWdlIC0tLS0tCj4gRnJvbTogQm9yaXNsYXYgUGV0a292IDw.Cj4gU2VudDogU2F0dXJkYXksIEZlYnJ1YXJ5IDE1LCAyMDE0IDM6MzAgUE0KPiBTdWJqZWN0OiBSZTogW0JVR10gdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlCj4gCj4gSWYgSSdkIGhhdmUgdG8gZ3Vlc3MsIHRoYXQncyB0cnlpbmcgdG8gcmN1IGRlcmVmIHRoYXQgc3RydWN0IG5ldF9nZW5lcmljCj4gKm5nIGluIG5ldF9nZW5lcmljKCkgYnV0IHRoaXMgaXMgb25seSABMAEBAQE-
X-Mailer: YahooMailWebService/0.8.177.636
References: <1392466251.41282.YahooMailNeo@web140003.mail.bf1.yahoo.com> <1392494917.71728.YahooMailNeo@web140002.mail.bf1.yahoo.com> <20140215203015.GA4528@pd.tnic>
Message-ID: <1392498262.98385.YahooMailNeo@web140003.mail.bf1.yahoo.com>
Date: Sat, 15 Feb 2014 13:04:22 -0800 (PST)
From: John <da_audiophile@yahoo.com>
Reply-To: John <da_audiophile@yahoo.com>
Subject: Re: [BUG] unable to handle kernel NULL pointer dereference
To: Borislav Petkov <bp@alien8.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "mlindner@marvell.com" <mlindner@marvell.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
In-Reply-To: <20140215203015.GA4528@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: Borislav Petkov <>
> Sent: Saturday, February 15, 2014 3:30 PM
> Subject: Re: [BUG] unable to handle kernel NULL pointer dereference
> 
> If I'd have to guess, that's trying to rcu deref that struct net_generic
> *ng in net_generic() but this is only guesswork as I don't have your
> .config.
> 
> Anyway, adding some more people to CC.
> 


Thanks for the reply, Boris.  The .config is unmodified from the Arch Distro default for 3.13.3-1 which can be found here: http://pastebin.com/LPGZ8ZqA
