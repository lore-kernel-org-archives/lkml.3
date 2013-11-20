Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab3KTOnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 09:43:10 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:61336 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab3KTOnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 09:43:03 -0500
X-Authority-Analysis: v=2.0 cv=LKjkseq9 c=1 sm=0 a=/DbS/tiKggfTkRRHPZEB4g==:17 a=Qsx_du5GiBkA:10 a=h_Sp9wbh10QA:10 a=PkNLigSBFxoA:10 a=S1A5HrydsesA:10 a=N659UExz7-8A:10 a=fxJcL_dCAAAA:8 a=KGjhK52YXX0A:10 a=FZWhsWj0kowA:10 a=QfKxxUxMAAAA:8 a=b43j7TwRUNC48_B710sA:9 a=pILNOxqGKmIA:10 a=/DbS/tiKggfTkRRHPZEB4g==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.78.168.186
Message-ID: <528CCA74.4040709@ubuntu.com>
Date: Wed, 20 Nov 2013 09:43:00 -0500
From: Phillip Susi <psusi@ubuntu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: Johan Hedberg <johan.hedberg@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: OOPS: Bluetooth: Store RFCOMM address information in its own
 socket structure
References: <528C2A68.1000304@ubuntu.com> <7410329D-F774-418E-8883-5A1171165113@holtmann.org>
In-Reply-To: <7410329D-F774-418E-8883-5A1171165113@holtmann.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/20/2013 2:53 AM, Marcel Holtmann wrote:
> fix for this is already in John’s wireless tree. On a side note,
> the bisect is correct, but it is not the patch that broke it. It is
> just the patch that uncovered it.

Great, thanks!


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSjMp0AAoJEJrBOlT6nu75SVcIAIdHUznWh7VjtCEebcF+LzGK
DGPReiaaRqHJMtd02Oka/3ARxwv9F2y8V/eYK9RIrE+6Wbi3uSOueqgWlz6mZQoo
cXNceyZngmwBmvQZJyDa3Eza/D/SBXclkkZu5F0J8umlY2y59FWNk2mBLJCYGJbB
o+SQgP6lwgUsB92PWLUJ4khd/oqsWYb9t5d2TJO1uMKCy2Gzr4y5EjXfoe7xluIw
UkzxW1TDO3bwBUlzB8u7bmJLt52D3+n2Tmc6YC819R67t/BqKDjbG+/kocEizrL5
w7QjsU0/HJw8b0E3jx3Y87z0fCdEAL2RibxUUuG5MIPjrFsh4QqDopqZ71+mbc4=
=G8YC
-----END PGP SIGNATURE-----
