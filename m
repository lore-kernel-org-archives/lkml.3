Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbaCBA06 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 19:26:58 -0500
Received: from nm26-vm5.bullet.mail.gq1.yahoo.com ([98.136.216.132]:22970 "EHLO
	nm26-vm5.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753328AbaCBA05 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 19:26:57 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 959380.30645.bm@omp1053.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=25EXswJNUNZvkfcAj7ljlUfk70aJi4+qExWat1drqxfaX9REgUNbqetoF+il4aaLGwLNeKyZFMo4m2UUZAb2svOZJzGJaMHXo6vSv7Ut6RIkh4apMovl/G7m7YdaY1tmKY5OFDKEyHNMkwrF3uHMi7eVR7SYbIMwYgSMMaebgC0=;
X-YMail-OSG: w.E6MrMVM1lnUPQaNaofaabEY3pY.GEqqPJ78xnePUTE5nn
 PaS3iZesiFm9_mOoFsGR2tsTvys8qB4bEVbxJnB0sZHZT54mjQzYEWtQVgFh
 Tabnab1VOfIds.5E9whjMTyZaw838xK4AmgWTs4lsN1aDF1NJmpOKViOcGlX
 Va1WuXiRgxujccHeO0X4qrYLQK.6OExgCxn1rpWcutGjF7Gel0XGpbiiSO5Z
 XDTc_E5jjJEFPogeMucb4K7E7hi2i1QwPL5rJF9VVRHsCm7WuBRa_s8DTaoI
 rkd36sN8VWVjJ1kKOsQIPshzR0Wu9_9c0mrSZLGBu..kJ7Tbi7kdzpeJYCa5
 MTtXvI4FRugVy0.JXEnMzkNEgP8zBfdbf0wQzg05KLRhxFioWyCnhb46ll8h
 _JDcMSW.Msh4v7OqFeASGwPwkm0ajOaF0F5g.ai0DIc9u4cLeQMdVYiYBoGr
 KMqboHfmzmoLG_J7rUcwmXpQyAMsLq1y53HvrJdagZS_xDyjBJ3myGacqc0G
 VT.uunIEEln.pjh_2xVlukmwgdQ--
X-Rocket-MIMEInfo: 002.001,Pk9uIFNhdHVyZGF5LCBNYXJjaCAxLCAyMDE0IDY6MTggUE0sIENoYXNlIFNvdXRod29vZCA8Y2hhc2Uuc291dGh3b29kQHlhaG9vLmNvbT4gd3JvdGU6Cgo.SGkgRGFuLAo.CltzbmlwXQo.Cj5JIGxpa2UgdGhpcyBpZGVhLiDCoEp1c3QgdG8gY2xhcmlmeSB0aG91Z2gsIGJhc2ljYWxseSBhbGwgb2YgdGhlIG1hY3JvcyB3b3VsZAo.Y2hhbmdlIHRvIHNvbWV0aGluZyBsaWtlwqAKPgo.I2RlZmluZSBBUENJMTU2NF9ESUdJVEFMX0lQIDB4NCAjZGVmaW5lIEFQQ0kxNTY0X0RJR0lUQUxfSVBfSU5URVJSVVBUX00BMAEBAQE-
X-Mailer: YahooMailWebService/0.8.177.636
References: <1393572680-9521-1-git-send-email-chase.southwood@yahoo.com> <1393669707-20107-1-git-send-email-chase.southwood@yahoo.com> <20140301124418.GT26776@mwanda> <1393719127.24160.YahooMailNeo@web164005.mail.gq1.yahoo.com>
Message-ID: <1393720016.67388.YahooMailNeo@web164006.mail.gq1.yahoo.com>
Date: Sat, 1 Mar 2014 16:26:56 -0800 (PST)
From: Chase Southwood <chase.southwood@yahoo.com>
Reply-To: Chase Southwood <chase.southwood@yahoo.com>
Subject: Re: [PATCH 1/2] Staging: comedi: introduce outl_1564_* and inl_1564_* helper functions in hwdrv_apci1564.c
To: Chase Southwood <chase.southwood@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1393719127.24160.YahooMailNeo@web164005.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Saturday, March 1, 2014 6:18 PM, Chase Southwood <chase.southwood@yahoo.com> wrote:

>Hi Dan,
>
[snip]
>
>I like this idea.  Just to clarify though, basically all of the macros would
>change to something like 
>
>#define APCI1564_DIGITAL_IP 0x4 #define APCI1564_DIGITAL_IP_INTERRUPT_MODE1 (0x4 + 0x4) >#define APCI1564_DIGITAL_IP_INTERRUPT_MODE2         (0x4 + 0x8) #define >APCI1564_DIGITAL_IP_IRQ (0x4 + 0x10) #define APCI1564_DIGITAL_OP 0x18 #define >APCI1564_DIGITAL_OP_RW 0x18 #define APCI1564_DIGITAL_OP_INTERRUPT (0x18 + 0x4) #define >APCI1564_DIGITAL_OP_IRQ (0x18 + 0xc)
>etc...  

[snip]

Ah shoot, well that was a copy/paste trainwreck.  Let's try that again, the macros would
look something like:

#define APCI1564_DIGITAL_IP 0x4
#define APCI1564_DIGITAL_IP_INTERRUPT_MODE1 (0x4 + 0x4)
#define APCI1564_DIGITAL_IP_INTERRUPT_MODE2 (0x4 + 0x8)
#define APCI1564_DIGITAL_IP_IRQ (0x4 + 0x10)

#define APCI1564_DIGITAL_OP 0x18
#define APCI1564_DIGITAL_OP_RW 0x18
#define APCI1564_DIGITAL_OP_INTERRUPT (0x18 + 0x4)
#define APCI1564_DIGITAL_OP_IRQ (0x18 + 0xc)


There, that's better.  Sorry about that.

Thanks,
Chase
