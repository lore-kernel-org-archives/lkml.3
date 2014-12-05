Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbaLEMtI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 07:49:08 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:18789 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbaLEMtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 07:49:06 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-5d-5481a9bf80a9
Message-id: <5481A954.1010104@samsung.com>
Date: Fri, 05 Dec 2014 14:47:16 +0200
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: David Howells <dhowells@redhat.com>
Cc: rusty@rustcorp.com.au, mmarek@suse.cz, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        zohar@linux.vnet.ibm.com
Subject: Re: [PATCH 4/5] MODSIGN: Provide a utility to append a PKCS#7
 signature to a module [ver #2]
References: <548172DE.9090007@samsung.com>
 <20141126141709.3944.66589.stgit@warthog.procyon.org.uk>
 <20141126141753.3944.22213.stgit@warthog.procyon.org.uk>
 <23280.1417775034@warthog.procyon.org.uk>
In-reply-to: <23280.1417775034@warthog.procyon.org.uk>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t/xy7r7VzaGGFy4x2rxruk3i8XsXQ9Z
	LC7vmsNm8aHnEZtFy74LTBY3p11gsfi0YhKzA7vHtBPLWDweHNrM4vF+31U2jxUbTjB7nFlw
	hN3j8ya5ALYoLpuU1JzMstQifbsEroxHz7YzFfxgrGjeM5W1gXEfYxcjJ4eEgInEhccr2SBs
	MYkL99YD2VwcQgJLGSU+P+1iB0kICTQySayazARhz2KU+DbVHMTmFdCSOPxjMdAgDg4WAVWJ
	1X/VQMJsAnoSG5p/gLWKCkRIfFj1lQ2iXFDix+R7LCC2iIC6xKNlG5lBbGaBJYwS02dGgowR
	FkiXeDFHAWLTGUaJCR1uIDangJlEw83TbCAlzEDj71/UguiUl9i85i0zRLmqRPfatVCfKEqc
	nnyOeQKj8Cwki2chdM9C0r2AkXkVo2hqaXJBcVJ6rqFecWJucWleul5yfu4mRki8fNnBuPiY
	1SFGAQ5GJR7eC9aNIUKsiWXFlbmHGCU4mJVEeJNnA4V4UxIrq1KL8uOLSnNSiw8xMnFwSjUw
	RtT9POOour7xbIsyywErP3/x5Ak3rmcqvPjHdTzb5prmH0nWbYVJ0YfOdk93la+veG1Qvezi
	6mmyj9xuev4N9QoTWlMw+e8HtymP3+b8F4rac8HgMb9XWzez6GrGElnBrad3TGBRrvtj9qhm
	TaOr569zbg3vLZ78ffxu6oIP4ksYTk7vr55ZpcRSnJFoqMVcVJwIACwvB4Z1AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/14 12:23, David Howells wrote:
> Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:
>
>> sign-file.c produce lots of annoying noise.
> How did you get it to produce that?
>
> David
>

With just "make all" on Ubuntu.


- Dmitry

