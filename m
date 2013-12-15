Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab3LOMXx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 07:23:53 -0500
Received: from nm19-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.162]:34300 "HELO
	nm19-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754085Ab3LOMXw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 07:23:52 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 376344.93298.bm@omp1041.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=yUkZfEQUvfFIowjGYTmavFrIeO6QUDZNg/VJrkBa7mnGes+yGhoElyIDKWQ6s8QruiZYnPJjCXjX1/wfw07irZapC1xIZsgZ0juAHgiZ2eK1fGE8h4/qGjS/VrJkBrB8rwPQO0uf//9uzLpgdJmycVyMQn4Z8ciNmAoROYTXqmk=;
X-YMail-OSG: tWgV3vgVM1kSX7R_RjnGQC0tSBLPtdj2vieQ499ujbOWgU5
 xbW0cZjvoZIInBNykhu5FtsXgHxR6oilaaK6n0BXzcJUW5U_Q2ruMzscCzo1
 IZwrWWO3ZZ4RqfH7vDhP1xuX4vQkq9VjB1S5ulbYk76Q8Wr5aYjiHKco.Edp
 SRjW.kggADeByNJ1H.oKJHBt75AmlsLXoy396T7aq3wULH44ORjwHGBQvQPO
 X3ZKrMMJQPPmzNWz5dAv17Nm1rp3YftocCcd9wJVJLsy7HmmT2xHJlno4Z50
 da7mMiDxYpYXGloCWEidk4icmltvOSQKMW6NyAphK7wgXNOqnV9598XPaVs5
 IlcbatHim1lSv3MKHbLnxTE3AYti7lrOKfGbIiqHTgrT940q34M0dz6Gny_d
 IdLALQzfFNfsqrsqDG9g.c1s3T2bBfeWahimdhhqQJ974PWdE9672.hE0UjF
 2DHMw6oNlF0VgAGpMPqqXxQ4qV2FZ4ZcMBHWUfgG.wNYieQ_LW6lUxhQCu3.
 vEjhfjehY_3BScEpOMPbRZMxN1Qz.znBYIpFSOhpUlW8Qn1IWJmiQXSIfUly
 aiJNLz0I4t5I1kPd9Tomf1ox328ISrjicBf0h5bKO47vRCFvASQSLcoZBw3S
 J3f8_G1OPQkBdTJAVTS2GEEJuVu6hXlrH2NNjzs19WkrchUx0DwEZ809ht2a
 JEM5zFG.cmjzFTM8-
X-Rocket-MIMEInfo: 002.001,PiBGcm9tOiBBdXN0aW4gUyBIZW1tZWxnYXJuIDw.Cj4gVGhpcyByZWFsbHkgZGVwZW5kcyBvbiBob3cgeW91IGRlZmluZSAnYmlnJy7CoCBFdmVuIGEgMSUgcGVyZm9ybWFuY2UKPiBpbmNyZWFzZSBpcyBzaWduaWZpY2FudCBmb3IgYSByZWFsdGltZSBzeXN0ZW0sIGFuZCBmb3Igc29tZW9uZSB3aXRoIGEKPiBjbHVzdGVyIG9mIHN5c3RlbXMsIGdldHRpbmcgZXZlbiBhIHNtYWxsIGltcHJvdmVtZW50IGluIHBlcmZvcm1hbmNlIG9uCj4gYWxsIG9mIHRoZSBzeXN0ZW1zIGNvdWxkIG1lYW4gYSBodWdlIGluY3IBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.169.609
References: <1386518000.90452.YahooMailNeo@web140004.mail.bf1.yahoo.com> <864985fbeb1d8148439e25ec01f47a67@ixit.cz> <52AAFF89.5080509@gmail.com>
Message-ID: <1387110231.99571.YahooMailNeo@web140006.mail.bf1.yahoo.com>
Date: Sun, 15 Dec 2013 04:23:51 -0800 (PST)
From: John <da_audiophile@yahoo.com>
Reply-To: John <da_audiophile@yahoo.com>
Subject: Re: [PATCH] expand micro-optimizations in kernel to newer model CPUs
To: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        David Heidelberger <david.heidelberger@ixit.cz>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <52AAFF89.5080509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Austin S Hemmelgarn <>
> This really depends on how you define 'big'.  Even a 1% performance
> increase is significant for a realtime system, and for someone with a
> cluster of systems, getting even a small improvement in performance on
> all of the systems could mean a huge increase in effective processing power.
> 

I have resubmitted per H. Peter Anvin's request:

http://lkml.indiana.edu/hypermail/linux/kernel/1312.1/04844.html


Please cc me on any replies as I am not subscribed to lkml.
