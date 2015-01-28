Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbbA2BaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:30:07 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:55622 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330AbbA2B3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:29:02 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tina Ruchandani <ruchandani.tina@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2] coredump: Use 64bit time for unix time of coredump
Date: Wed, 28 Jan 2015 12:31:10 +0100
Message-ID: <10182197.2ytoa1pSci@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20150128051606.GA4659@tinar>
References: <20150128051606.GA4659@tinar>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:+qoP2AHL+R8NjEbzuKDMaPk+y0EoB8YRoBnfWpLL3SdEc1hkj1j
 BmoWXZfyCf9gi/ksqGBuzNkrqEpbwQhEF8LhgYrvsStLV7w0tSxKxyDmwwRPg1v+cN41nmM
 J7fkNd0j9tt9lF66rhc6vIAdmmzoYfpj4PLbjxOhtMX4oN0xXPQqOF5NVlGyjP18u6nQ9W2
 KfpCJFKy6PrMwCulU0okA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 January 2015 10:46:06 Tina Ruchandani wrote:
> struct timeval on 32-bit systems will have its tv_sec
> value overflow in year 2038 and beyond.
> Use a 64 bit value to print time of the coredump in seconds.
> ktime_get_real_seconds is chosen here for efficiency reasons.
> 
> Suggested by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
