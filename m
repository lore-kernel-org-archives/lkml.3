Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab3JGWpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 18:45:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60749 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785Ab3JGWpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 18:45:05 -0400
Message-ID: <52533965.3080906@zytor.com>
Date: Mon, 07 Oct 2013 15:44:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Geyslan G. Bem" <geyslan@gmail.com>
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kernel-br@googlegroups.com
Subject: Re: [PATCH] x86: mkpiggy.c: fix resource leakage
References: <1381184219-10985-1-git-send-email-geyslan@gmail.com>
In-Reply-To: <1381184219-10985-1-git-send-email-geyslan@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 03:16 PM, Geyslan G. Bem wrote:
> Even though the resource is released when the application is closed or
> when returned from main function, modified to make it in accordance.
> Now FILE pointer is always verified.

By the way, the subject is misleading - there is no resource leakage
since the program is terminated anyway.

	-hpa


