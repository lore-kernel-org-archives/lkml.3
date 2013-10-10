Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab3JJS56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 14:57:58 -0400
Received: from smtp2.peak6.com ([38.98.137.9]:45445 "EHLO smtp2.peak6.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756260Ab3JJS5z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 14:57:55 -0400
X-AuditID: 0a02cb20-b7f5e6d00000250f-1c-5256f8b27318
From: Shaun Thomas <sthomas@optionshouse.com>
To: "'Matt'" <jackdachef@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: RE: Very odd memory behavior. Is this normal?
Thread-Topic: Very odd memory behavior. Is this normal?
Thread-Index: AQHOxel98LW9O+ThMUuaL3oPPhjaNJnum5sA//+s3bA=
Date: Thu, 10 Oct 2013 18:57:53 +0000
Message-ID: <0683F5F5A5C7FE419A752A034B4A0B97973FD07B@sswchi5pmbx2.peak6.net>
References: <CAG-aW07mUqX5t-g4_cCvSVxrArzmc-vsOaPoHcFJuo_fXeRnzw@mail.gmail.com>
 <CAG-aW07kVTurn2mTH_2qR31wdOEzxfP34-6eR34MvNZaMkGYkw@mail.gmail.com>
In-Reply-To: <CAG-aW07kVTurn2mTH_2qR31wdOEzxfP34-6eR34MvNZaMkGYkw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.10.200.64]
Content-Type: text/plain; charset="us-ascii"
content-transfer-encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsXClcIrprvpR1iQwfLP8hYrph5ls7i8aw6b
	A5PHzll32T0+b5ILYIpqYLRJzMvLL0ksSVVISS1OtlXyLyjJzM8r9sgvLU5VcMksTs5JzMxN
	LVJSyEyxVTJWUijISUxOzU3NK7FVSiwoSM1LUbLjUsAANkBlmXkKqXnJ+SmZeem2Sp7B/roW
	FqaWuoZKdvHIIKGTJWNR5yz2gqssFRcWrWFpYHzO3MXIySEhYCLxZu8BNghbTOLCvfVANheH
	kMABRomW3otMEM4yRonT006zgFSxCehKTOpfAdYhIqAocfzVAfYuRg4OZgF9iZNPXUFMYQEz
	ifvXZCAqzCVuX9vIAmFbSfw7s5oRxGYRUJV4vPsFmM0r4CvxoP01M8Sq6YwS1xongI3nFAiU
	mPfzFyuIzQh03PdTa5hAbGYBcYlbT+YzQRwtILFkz3moZ0QlXj7+xwphK0gsOHGeFaJeR2LB
	7k9sELa2xLKFr5khFgtKnJz5hGUCo9gsJGNnIWmZhaRlFpKWBYwsqxjFi8sSkzMyzQqKc0sK
	jPQKUhOzzfTyUks2MYISBtNphR2Mm3usDjEKcDAq8fBO6A4NEmJNLCuuzD3EKMHBrCTCq/o6
	LEiINyWxsiq1KD++qDQntfgQow8wcCYyS4km5wOTWV5JvKGxqYGppamhqbmpoREOYSVx3n1M
	ywKFBNKBSSw7NbUgtQhmHBMHp1QDI4tcrcikHbOD2n4E7WPrD4939HtgkhMiK2PDu3mdYIxj
	40SjVyvab7TM8j/9ze3WkvdBTFVL+NasXvXoJo8u9zLxnfsqAv7ZBvuo7ufWOyBzhGsKt1DY
	n/dHPRjMLWw/+6eIxz86cqLi8ZwDFzqenFjjb7xwS6FMst31eVLKNUntjz8sXWJgrsRSnJFo
	qMVcVJwIAOqIY6lFAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> just a user here, with a little android-kernel related experience who
> also likes to tinker with the desktop kernel :)
> 
> Have you given the following patchset a try yet:
> 
> http://linux-kernel.2935.n7.nabble.com/patch-v2-0-3-mm-improve-
> page-aging-fairness-between-zones-nodes-td696105.html

Holy cow, that looks extremely promising. What version of the kernel is this compatible with? It looks like 3.11, but I'm not sure.

Thanks!

--
Shaun Thomas
OptionsHouse | 141 W. Jackson Blvd | Suite 500 | Chicago IL, 60604
312-676-8870
sthomas@optionshouse.com





______________________________________________

See http://www.peak6.com/email_disclaimer/ for terms and conditions related to this email
