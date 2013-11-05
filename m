Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab3KECp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 21:45:28 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:45883 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab3KECp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 21:45:26 -0500
X-Authority-Analysis: v=2.0 cv=FKiZNpUs c=1 sm=0 a=3SewDSjaRW4vdJyuxQ33ZQ==:17 a=DeBnktw0k-IA:10 a=AizhB-pfR1kA:10 a=2uJ6EyLEdLkA:10 a=S1A5HrydsesA:10 a=IkcTkHD0fZMA:10 a=fxJcL_dCAAAA:8 a=KGjhK52YXX0A:10 a=8LyGJxwqpqQA:10 a=QfKxxUxMAAAA:8 a=ZvtQACrnleSx_ipsllwA:9 a=QEXdDO2ut3YA:10 a=Ktp2EsrM7zEA:10 a=3SewDSjaRW4vdJyuxQ33ZQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 72.238.73.171
Message-ID: <52785BC5.9020205@ubuntu.com>
Date: Mon, 04 Nov 2013 21:45:25 -0500
From: Phillip Susi <psusi@ubuntu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Aaron Lu <aaron.lu@intel.com>, linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] libata: avoid waking disk to check power
References: <1383612780-6591-1-git-send-email-psusi@ubuntu.com> <1383612780-6591-2-git-send-email-psusi@ubuntu.com> <52785A5F.4060001@intel.com>
In-Reply-To: <52785A5F.4060001@intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 11/04/2013 09:39 PM, Aaron Lu wrote:
> If the disk entered sleep mode due to runtime PM, then udisks can
> easily tell by checking the device's runtime status and not send
> out the query.
> 
> But if the disk entered sleep mode due to other reason, the patch
> may be necessary. So what's your scenario?

I am planning on patching udisks to do that as well, but if you have a
current udsisk or manually run hdparm -C, or some other program is
doing something similar, then this patch takes care of that.



-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJSeFvFAAoJEJrBOlT6nu75hcYH/0YsYcs3u9Dmuqq9z5kFXL3k
C4xYQtvOxw2z+B/vEFzdym5J3ZfVyT4+ZdcHMvRgbbPH+R8/rzNC+F3OjdGtDIRA
5EUo0BUT2IfY0Yp2SzP44+8aRC4iF5jLLcH9XJKQx7WHedJQ7puCgJXXHAgUhpwW
52gJ0UEHnjlBgjwxY9RKqppnJs57x2VwgwR2BeFns6Hcry0S0HN0U4gwROmb1GZR
kjpOUUYHb3MH/gfzCaY97t0duAAp7jzZeOIuu+XHfkyV3APwsnbasLOOoRYtpbvQ
M++xmYQdNAh2DcZLEmAo6H6HLB/Z5d9K0+SKUFnsKHFaUCH0GPHm8SZ7E/NN7ig=
=7c7v
-----END PGP SIGNATURE-----
