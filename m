Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648AbaCUPDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 11:03:06 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:36370 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbaCUPDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 11:03:02 -0400
X-Authority-Analysis: v=2.0 cv=GbyVbHrL c=1 sm=0 a=/DbS/tiKggfTkRRHPZEB4g==:17 a=h2n2wN--3AMA:10 a=IBrS0yOrj2QA:10 a=S1A5HrydsesA:10 a=Qsx_du5GiBkA:10 a=8nJEP1OIZ-IA:10 a=fxJcL_dCAAAA:8 a=KGjhK52YXX0A:10 a=QfKxxUxMAAAA:8 a=qYczfrIZeFRGOLxBN1oA:9 a=wPNLvfGTeEIA:10 a=/DbS/tiKggfTkRRHPZEB4g==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.78.168.186
Message-ID: <532C54A3.3030903@ubuntu.com>
Date: Fri, 21 Mar 2014 11:02:59 -0400
From: Phillip Susi <psusi@ubuntu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Karel Zak <kzak@redhat.com>,
        Janani Venkataraman <jananive@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, util-linux@vger.kernel.org
Subject: Re: [PATCH 00/33] [RFC] Non disruptive application core dump infrastructure
References: <20140320093040.14878.903.stgit@localhost.localdomain> <20140321080855.GE26374@x2.net.home>
In-Reply-To: <20140321080855.GE26374@x2.net.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 3/21/2014 4:17 AM, Karel Zak wrote:
> The gencore command looks like a good idea, but why we need the 
> client-server infrastructure? At least at first glance it seems 
> like overkill.

Yes, the server seems pointless.

>> We would like to push this to one of the following packages: a)
>> util-linux b) coreutils c) procps-ng
> 
> d) somewhere near to gdb :-)

gdb already has such a thing; it's called gcore.  Kind of makes this
work seem redundant?


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTLFSjAAoJEI5FoCIzSKrwuTIH/jGtc3dB1WKgtDSE2wtXXHO0
0WxhWDbVkpJ0Q+tkG/tjw4wudYtEJ+XAHsCIK3vH7OMX7i4PMOLDgjT/FyxTPrWl
W+eUCazi4vRPNGscii5mRFlsthgEd2pofotlx5UB7Br9D05/QZqErtEMJMqD935V
94wlvJSvJI0n3hfAUgcM8apxTgxYr/TIPEQPfqLem3xTZIw3lTRic613Qji2Kwif
l+kqs0WLy/AHEwBLRrXDQahnv5n2IhOVUn3KDwm9Su56rbrmAF7LAvK0+uxRyoQk
IVC5h8BdBQ4QMYl7KYYEPy+n+0Qbe1EQ4tLmYvaEBwXP5c0QDGX0M5VUkko+eGI=
=zFoW
-----END PGP SIGNATURE-----
