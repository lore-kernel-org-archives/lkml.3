Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421Ab3EHNnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 09:43:24 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:64993 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544Ab3EHNnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 09:43:22 -0400
X-Authority-Analysis: v=2.0 cv=cYNQXw/M c=1 sm=0 a=/DbS/tiKggfTkRRHPZEB4g==:17 a=Qsx_du5GiBkA:10 a=_nfIMGA1H_4A:10 a=dwL0LKpTL8MA:10 a=S1A5HrydsesA:10 a=IkcTkHD0fZMA:10 a=fxJcL_dCAAAA:8 a=LH0XCIorE3gA:10 a=QfKxxUxMAAAA:8 a=V_PUL_o95yypbRTWXAUA:9 a=QEXdDO2ut3YA:10 a=/DbS/tiKggfTkRRHPZEB4g==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.78.168.186
Message-ID: <518A5677.60203@ubuntu.com>
Date: Wed, 08 May 2013 09:43:19 -0400
From: Phillip Susi <psusi@ubuntu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Artem S. Tashkinov" <t.artem@lycos.com>
CC: patrik.r.jakobsson@gmail.com, bhelgaas@google.com, hancockrwd@gmail.com,
        stern@rowland.harvard.edu, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, rjw@sisk.pl
Subject: Re: Abysmal HDD/USB write speed after sleep on a UEFI system
References: <CAErSpo7qj2SNR7BfuBsfF-saZXvgcqqLtgoP5Hyb5u99qR4Ncg@mail.gmail.com> <569718148.80620.1361906088301.JavaMail.mail@webmail13> <CAErSpo6UkVhSf+nFW4zwJLBQw_0RQ5H9Bv-UuQRb6zdwsFPw4g@mail.gmail.com> <CAErSpo4X+XXKvWDfqh2CKZAtJ9WMQk91OcsWwdxwYv2MfEM_zQ@mail.gmail.com> <771333906.75854.1367057440028.JavaMail.mail@webmail08> <CAErSpo4B4sRco-nuqgXiYtGQxBcbEB6ArQjHD0A9cj4TRE+qQw@mail.gmail.com> <518097B8.4020402@gmail.com> <CAErSpo7KWPRVEnw+n068pUZz+=WSTwno6m6t7N6dunuhnFC8EA@mail.gmail.com> <384171828.66802.1367942365492.JavaMail.mail@webmail05> <CADLC3L3bdTP8-X3ftMq1qxnL=LVDf7d5gbu2ZMH0pXg2AU8xjw@mail.gmail.com> <CAErSpo50iyEbCer+-K8uXUdnsG_EzFe_ZjKnrtfq5x0Zw3Yd6w@mail.gmail.com> <CAMeQTsZEpRE_bv6o9mBpqNrbf36SZVscxy+JS72=BOzA1ey-XQ@mail.gmail.com> <CAErSpo75SETEe-OKhY2-NW3csaxt=f09JcheHx95bzkCcGO6yg@mail.gmail.com><CAMeQTsY1jc99boFC_KDTL=-Pt-W1q5ZiS+r89QkPE+vAk386UQ@mail.gmail.com> <1786821921.88859.1368002273356.JavaMail.mail@webmail05>
In-Reply-To: <1786821921.88859.1368002273356.JavaMail.mail@webmail05>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 5/8/2013 4:37 AM, Artem S. Tashkinov wrote:
> Have you tried suspending more than three times? In the absence of
> UEFI boot this bug emerges only on a third or even fourth resume
> attempt. UEFI boot triggers it immediately on a first resume
> though.

I suspend my P8P67 every night.  One thing that does come to mind now
though, is that when I first built it, there was a problem involving
suspend and the firewire driver, but IIRC, it manifested as a failure
to suspend with an error in dmesg, so I disabled the firewire
controller since I have no use for it.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRilZ2AAoJEJrBOlT6nu75IbkH/RdaAwGoBbJbkTxh4vhR3l/+
nILa2X83WwEYADozNL7zi2w8AExTBHzfKZeE7uzXLPzsryPxJxAQY+LtXwRdCHQy
GXVKZL2TpxPsNQTv1uhdCRiSTgIm9U1Y/INPZ2ugn+WbiH9iXzhRzLRgKH3kALO4
OvReW/XQeZ77RP6IaffnoLbStpORAXH+Ttnt5nMdLvm/rGuBlUsyDvT9TAAcF3W1
1muRJnzpDdMj+Ibwn/IW5smp9RBm2EJb2aP2N+KOV7WgiwPC+8T7omWV6Fjl+NI7
xrc8BQTGVfbZJXpeg2KH7v5Ty+M4xFYfdCJjLocL3rFJCYR+3WCDqpRB+I55Yvo=
=eIDL
-----END PGP SIGNATURE-----
