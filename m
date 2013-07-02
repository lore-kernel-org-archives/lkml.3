Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab3GBIyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 04:54:11 -0400
Received: from nm11-vm10.access.bullet.mail.bf1.yahoo.com ([216.109.114.233]:28546
	"EHLO nm11-vm10.access.bullet.mail.bf1.yahoo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932422Ab3GBIyI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 04:54:08 -0400
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Jul 2013 04:54:08 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 14169.9462.bm@omp1004.access.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=mayfV23aJvn11QHFlKIzNGEShhpW+JWDI2h+AILudrSeo9y6K0Qxamtpc5i2qKJgBmmkWejNpcyRjEGdpqLVSuANYy8ZzJgG7WetdwbVgycREIi48B9ZCJLIWQwrSLVVNQzZukRU6ttU6VMG0F2/mBPGHJ7d6cpDbstA5ovmcbU=  ;
X-YMail-OSG: PgK_V5MVM1ns68W6AOifuXk72ryirvBV7M5AOKO6hn.nAIR
 rjvFqTKIIYHuLLvH7lACQnG1_1Uv7rsSbqnpNinrSk9Xf7u1Kc5Kp1tsZgXZ
 4VB.uzXM3sd_DsMcE_SZ6NvlipRMWmHvEv0fh0O2G4LWDgJ2vjiEkXzIg5BR
 EBJg_grr3ZWrHDJkGpt8lYNkJndLUdFjLDOaz3wEe6Vcv5rM4CW5iy7JpL4V
 6RRymBtJzMhFWUo6gnjegKZPcHpQW6gNPIXuYZ9lCeg4z1jQLWwY3EkmxcE.
 5ljDtJpQDWHFdgS4Fnk5o6mybSAwJta19RlfAFACLm1NpSChuCeBMQHtu6Si
 gjVKtGTbRBrOuPzq.Dhps_UwJV8rM1EeBBjarhDi2h1cSkyz05aehMsY8PfU
 ksxiHz9092IJNGGt1pumhC1565bOsrhoCZVEiDt9kcqqdPwqLOZpxYkjasXF
 KJOO5XrNYQCIPNyPk_FDBD9sZyBkpJrkHLFsbyAOp__7QA1l1cXD7oJg62JG
 i42QnOhuF2k.vJZdDevus6OUapYDH0qUcr9xZNOo01N6_SYHGfkuL8_1KUPX
 dc2Fw4td.EpSbhTJfgb7HGY4glVK3KFzjf2DSLAt_IIQOau1wZ.d58NXsaEd
 Gh_761A--
X-Rocket-MIMEInfo: 002.001,Pj4gTGludXgga2VybmVsIGJ1aWxkLCB3aGlsZSBjb3JyZWN0LCBpcyBzb21ld2hhdCBzbG93LCBhbmQgdGhlIHNvdXJjZXMKCj4.IGNvdWxkIGJlIG1vcmUgcmVhZGFibGUuCgpHcmVnIHdyb3RlOgo.SG93IGlzIGl0ICJzbG93Ij8gwqAKCldlbGwsIHRoZSBwcm9wb3J0aW9uIG9mIHRpbWUgc3BlbnQgYnkgdGhlIENQVSBjb3JlcyBvbiBhY3Rpdml0aWVzIG90aGVyIHRoYW4gY29tcGlsaW5nIHNlZW1lZCBoaWdoLgoKCj5XaGF0ICJzb3VyY2VzIiBhcmUgeW91IHJlZmVycmluZyB0byBhcyBiZWluZyBub3QgcmUBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.148.557
References: <1372723921.53875.YahooMailNeo@web182202.mail.bf1.yahoo.com> <20130702044516.GA31484@kroah.com>
Message-ID: <1372754805.73620.YahooMailNeo@web182206.mail.bf1.yahoo.com>
Date: Tue, 2 Jul 2013 01:46:45 -0700 (PDT)
From: Mark Galeck <mark_galeck@pacbell.net>
Reply-To: Mark Galeck <mark_galeck@pacbell.net>
Subject: Re: is it desirable to improve the build system?
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20130702044516.GA31484@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Linux kernel build, while correct, is somewhat slow, and the sources

>> could be more readable.

Greg wrote:
>How is it "slow"?  

Well, the proportion of time spent by the CPU cores on activities other than compiling seemed high.


>What "sources" are you referring to as being not readable?

Not "not readable at all", just "could be made more readable" - the main Makefile and other main Make files; it seemed that one reason, IMHO, was not enough comments. 


>What do you not understand that you think could be changed?

I did not make careful notes in that area (details would come back to me if I look at this carefully), but right now I remember two things.

As every child in kindergarten knows, recursive make is bad (except when it is good, which you learn in primary school). One reason is that all that re-parsing costs time. Linux kernel build is very heavy recursive.

Frequent use of FORCE phony prerequisites to circumvent the normal GNU Make recipe avoidance mechanism, and then using a custom recipe mechanism to decide what to execute, seems to go against the philosophy of the tool being used (GNU Make) and as such seems, IMHO, to also waste time.

Of course if one were to attempt a change, the first thing would be to do look carefully at the amount of time spent on such activities, rather than using words such as "seems". 


What I don't understand of course is the reasons behind these choices have been made.


>Have you looked at the history of the build code to help understand why
things were changed to be they way they are?  git should help you out
here.

No. IMHO, looking at source, and especially past history thereof, to understand it, is a very inefficient use of one's time, only to be undertaken if all else fails. Much better is looking at comments and documentation, if available, and also, asking well-informed persons such as yourself.  


Mark
